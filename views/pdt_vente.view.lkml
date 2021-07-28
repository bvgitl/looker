view: pdt_vente {
  derived_table: {
    sql: select distinct  m.Animateur as Animateur ,
        DATE_OUV as Dte_Ouverture,
        Directeur as Directeur ,
        Franchise as Franchise ,
        Nom_TBE as NOM,
        Type_TBE as Typ ,
        Pays_TBE as Pays ,
        Region as Region ,
        SURF_VTE as Surface ,
        TYP_MAG as TYP_MAG,
        Tranche_age as Anciennete,
        m.CD_Magasin as CD_Magasin ,
        v.CD_Site_Ext as CD_Site_Ext ,
        day as Dte_Vte ,
        v.Typ_Vente as Typ_Vente ,
        v.Val_Achat_Gbl as Val_Achat_Gbl,
        v.Qtite as Qtite,
        v.ca_ht as ca_ht,
        v.marge_brute as marge_brute,
        mag.nb_ticket as nb_ticket,
        t.Qt_tracts as Qte_tracts,
        t.Mise_en_avant_web as web,
        t.E_mail as E_mail,
        t.SMS as SMS,
        t.Booster_Bonial as Booster_Bonial,
        t.Spot_RadioShop as Spot_RadioShop,
        t.PLV_Moyen_Kit as PLV_Moyen_Kit,
        t.PLV_Grand_Kit as PLV_Grand_Kit,
        t.Date_de_debut as Date_de_debut,
        t.Date_de_fin as Date_de_fin,
        c.nbre_commande as nbre_commande,
        c.Tarif_HT_livraison as Tarif_HT_livraison,
        c.Total_HT as Total_HT

        from  `bv-prod.Matillion_Perm_Table.Magasins` m,

(SELECT day
FROM UNNEST(
    GENERATE_DATE_ARRAY(DATE('2018-01-02'), CURRENT_DATE(), INTERVAL 1 DAY)
) AS day)

LEFT JOIN (


(select
        RIGHT(CONCAT('000', CD_Site_Ext),3)  as CD_Site_Ext ,
        Dte_Vte ,
        Typ_Vente ,
        sum(Val_Achat_Gbl) as Val_Achat_Gbl ,
        sum(Qtite) as Qtite ,
        sum(ca_ht) as ca_ht ,
        sum(marge_brute) as marge_brute
      from `bv-prod.Matillion_Perm_Table.TF_VENTE`
      group by 1,2,3

      UNION ALL

select
        CD_SITE_EXT ,
        DTE_VENTE ,
        TYP_VENTE ,
        sum(VAL_ACHAT_GBL) as Val_Achat_Gbl ,
        sum(QTITE) as Qtite ,
        sum(CA_HT) as ca_ht,
        sum(MARGE_BRUTE) as marge_brute
      from `bv-prod.Matillion_Perm_Table.GOOGLE_SHEET`
      group by 1,2,3

      ) v




  INNER JOIN


  (
    select
    RIGHT(CONCAT('000', CD_Site_Ext),3)  as CD_Site_Ext ,
    Dte_Vte,
    Typ_vente,
    sum(nb_ticket) as nb_ticket
    from `bv-prod.Matillion_Perm_Table.TF_VENTE_MAG`
    group by 1,2,3
  ) mag

  ON mag.CD_Site_Ext = v.CD_Site_Ext

  AND mag.Dte_Vte = v.Dte_Vte

  AND v.Typ_vente = mag.Typ_vente )


  ON m.CD_Logiciel = v.CD_Site_Ext and day = v.Dte_Vte


  LEFT JOIN `bv-prod.Matillion_Perm_Table.TRACTS` t
    ON  m.cd_magasin = t.code_bv and day between t.Date_de_debut and t.Date_de_fin


  LEFT JOIN

  (SELECT
      cd_magasin,
      CAST(DATETIME_TRUNC(DATETIME(dte_commande), DAY) AS DATE) AS dte_cde,
      count(distinct(cd_commande)) as Nbre_commande ,
      sum(Tarif_HT_livraison) as Tarif_HT_livraison,
      sum(Total_HT) as Total_HT
      FROM `bv-prod.Matillion_Perm_Table.COMMANDES`
      where statut IN ("pending", "processing" , "fraud", "complete")
       group by 1,2
) as c


  ON c.cd_magasin = m.CD_Magasin  and day = c.dte_cde



 ;;

      persist_for: "24 hours"
    }

    measure: count {
      hidden: yes
      type: count
      drill_fields: [detail*]
    }

    dimension: cd_magasin {
      type: string
      sql: ${TABLE}.CD_Magasin ;;
      view_label: "Magasins"
    }

    dimension: animateur {
      type: string
      sql: ${TABLE}.Animateur ;;
      view_label: "Magasins"
    }


    dimension: directeur {
      type: string
      sql: ${TABLE}.Directeur ;;
      view_label: "Magasins"
    }

    dimension: franchise {
      type: string
      sql: ${TABLE}.Franchise ;;
      view_label: "Magasins"
    }

    dimension: nom {
      type: string
      sql: ${TABLE}.NOM ;;
      view_label: "Magasins"
    }

    dimension: typ {
      type: string
      sql: ${TABLE}.Typ ;;
      view_label: "Magasins"
    }

    dimension: pays {
      type: string
      sql: ${TABLE}.Pays ;;
      view_label: "Magasins"
    }

    dimension: region {
      type: string
      sql: ${TABLE}.Region ;;
      view_label: "Magasins"
    }

    dimension: surface {
      type: number
      sql: ${TABLE}.Surface ;;
      view_label: "Magasins"
    }

    dimension: typ_mag {
      type: string
      sql: ${TABLE}.TYP_MAG ;;
      view_label: "Magasins"
    }

    dimension: anciennete {
      type: string
      sql: ${TABLE}.Anciennete ;;
      view_label: "Magasins"
    }

    dimension: cd_site_ext {
      hidden: yes
      type: string
      sql: ${TABLE}.CD_Site_Ext ;;
    }

    dimension_group: dte_ouverture {
      type: time
      timeframes: [
        raw,
        date,
        year
      ]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.Dte_Ouverture ;;
      view_label: "Magasins"
    }

    dimension_group: dte_vte {
      type: time
      timeframes: [
        raw, date, week, month, month_name, quarter, year,
        fiscal_month_num, fiscal_quarter, fiscal_quarter_of_year, fiscal_year
      ]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.Dte_Vte ;;
      view_label: "Ventes"
    }

    dimension: typ_vente {
      type: number
      sql: ${TABLE}.Typ_Vente ;;
      view_label: "Ventes"
    }

    dimension: val_achat_gbl {
      type: number
      sql: ${TABLE}.Val_Achat_Gbl ;;
      view_label: "Ventes"
    }

    dimension: qtite {
      type: number
      sql: ${TABLE}.Qtite ;;
      view_label: "Ventes"
    }

    dimension: ca_ht {
      type: number
      sql: ${TABLE}.ca_ht ;;
      view_label: "Ventes"
    }

    dimension: marge_brute {
      type: number
      sql: ${TABLE}.marge_brute ;;
      view_label: "Ventes"
    }

    dimension: nb_ticket {
      type: number
      sql: ${TABLE}.nb_ticket ;;
      view_label: "Ventes"
    }

    dimension: qte_tracts {
      type: number
      sql: CASE
            WHEN {% condition date_filter %} CAST(${date_de_debut_date} AS TIMESTAMP)  {% endcondition %}
                or {% condition date_filter %} CAST(${date_de_fin_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${TABLE}.Qte_tracts
          END ;;
      view_label: "Tracts"
    }

    dimension: web {
      type: number
      sql: ${TABLE}.web ;;
      view_label: "Tracts"
    }

    dimension: e_mail {
      type: number
      sql: ${TABLE}.E_mail ;;
      view_label: "Tracts"
    }

    dimension: sms {
      type: number
      sql: ${TABLE}.SMS ;;
      view_label: "Tracts"
    }

    dimension: booster_bonial {
      type: number
      sql: ${TABLE}.Booster_Bonial ;;
      view_label: "Tracts"
    }

    dimension: Digital_tract {
    type: number
    sql: CASE
            WHEN {% condition date_filter %} CAST(${date_de_debut_date} AS TIMESTAMP)  {% endcondition %}
                or {% condition date_filter %} CAST(${date_de_fin_date} AS TIMESTAMP)  {% endcondition %}
            THEN (CASE
                    WHEN ${web} = 1 or ${booster_bonial} = 1 THEN 1
                  END )
        END;;
      view_label: "Tracts"
    }

    dimension: spot_radio_shop {
      type: number
      sql: ${TABLE}.Spot_RadioShop ;;
      view_label: "Tracts"
    }

    dimension: plv_moyen_kit {
      type: number
      sql: ${TABLE}.PLV_Moyen_Kit ;;
      view_label: "Tracts"
    }

    dimension: plv_grand_kit {
      type: number
      sql: ${TABLE}.PLV_Grand_Kit ;;
      view_label: "Tracts"
    }

    dimension_group: date_de_debut {
      type: time
      timeframes: [raw,date,year]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.Date_de_debut ;;
      view_label: "Tracts"
    }

    dimension_group: date_de_fin {
      type: time
      timeframes: [raw,date,year]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.Date_de_fin ;;
      view_label: "Tracts"
    }

    dimension: total_ht {
      type: number
      sql: ${TABLE}.Total_HT ;;
      view_label: "Web"
    }


    dimension: tarif_ht_livraison {
      type: number
      sql: ${TABLE}.Tarif_HT_livraison ;;
      view_label: "Web"
    }

    dimension: nbre_commande {
      type: number
      sql: ${TABLE}.Nbre_commande ;;
      view_label: "Web"
    }

    set: detail {
      fields: [
        cd_magasin,
        animateur,
        directeur,
        franchise,
        nom,
        typ,
        pays,
        region,
        surface,
        typ_mag,
        anciennete,
        cd_site_ext,
        typ_vente,
        val_achat_gbl,
        qtite,
        ca_ht,
        marge_brute,
        nb_ticket,
        qte_tracts,
        web,
        e_mail,
        sms,
        booster_bonial,
        spot_radio_shop,
        plv_moyen_kit,
        plv_grand_kit,
        total_ht,
        nbre_commande
      ]
    }

    filter: date_filter {                 ### Choisir la période qu'on souhaite obtenir les résultats###
      label: "Période n"
      type: date
      view_label: "Période"
      group_label: "Année N"
    }

    filter: date_filter_1 {               ### Choisir la période qu'on souhaite obtenir les résultats###
      label: "Période n-1"
      type: date
      view_label: "Période"
      group_label: "Année N-1"
    }

  filter: date_filter_2 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n-2"
    type: date
    view_label: "Période"
    group_label: "Année N-2"
  }

  filter: date_filter_3 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n-3"
    type: date
    view_label: "Période"
    group_label: "Année N-3"
  }

    dimension: categorie {
      hidden: no
      label: "Catégorie"
      sql:
        CASE
          WHEN ${typ} = "S"  OR
          ${dte_ouverture_date} > CAST ({% date_start date_filter_3 %} AS DATETIME) THEN "P. non Comparable"
          WHEN ${dte_ouverture_date} <= CAST ({% date_start date_filter_3 %} AS DATETIME) THEN "P.Comparable"
        END
    ;;
      view_label: "Magasins"
    }


    dimension: Type_retrocession {
      sql: CASE
            WHEN ${typ_vente} = 0 THEN "Hors rétrocession"
            ELSE "Rétrocession"
          END ;;
      view_label: "Ventes"
    }


  dimension: Groupe_Region {
    sql: CASE
            WHEN ${region} IN ("RN","RNE", "RNW", "RRA", "RSE", "RSW") THEN "France Metro"
            WHEN ${region} IN ("BE", "CAM", "ESP", "IT", "MAL", "MAU", "TOM", "TUN") THEN "International"
          END ;;
    view_label: "Magasins"
  }


########################## Calcul global des KPIs ################################

    measure: sum_ca_ht {
      type: sum
      value_format_name: eur
      sql: ${ca_ht} ;;
      view_label: "Ventes"
    }

    measure: count_dte_vente {
      hidden: yes
      value_format_name: decimal_0
      type: count_distinct
      sql: ${TABLE}.dte_vente ;;
      view_label: "Ventes"
    }

    dimension: tot_tx_marge_brute {
      type: number
      value_format_name: percent_2
      sql:  1.0 * ${marge_brute}/NULLIF(${ca_ht},0) ;;
      view_label: "Ventes"
    }

    measure: sum_marge_brute {
      hidden: yes
      value_format_name: eur
      type: sum
      sql: ${marge_brute} ;;
      view_label: "Ventes"
    }

    measure: sum_nb_ticket {
      hidden: yes
      value_format_name: decimal_0
      type: sum
      sql: ${nb_ticket} ;;
      view_label: "Ventes"
    }

    measure: sum_qtite {
      hidden: yes
      value_format_name: decimal_0
      type: sum
      sql: ${qtite};;
      view_label: "Ventes"
    }

    measure: sum_val_achat_gbl {
      hidden: yes
      value_format_name: eur
      type: sum
      sql: ${val_achat_gbl} ;;
      view_label: "Ventes"
    }


    ############## calcul des KPIs à la période sélectionnée au niveau du filtre  ############

    measure: sum_CA_select_mois {
      type: sum
      value_format_name: eur
      label: "CA HT"
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: sum_marge_select_mois {
      label: "Marge"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: sum_nb_ticket_select_mois {
      label: "Nb clts"
      type: sum
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nb_ticket}
          END ;;
      view_label: "Clients"
      group_label: "Année N"
    }

    measure: sum_nb_jour_select_mois {
      label: "Nb jr"
      type: count_distinct
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: sum_val_achat_gbl_select_mois {
      hidden: yes
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
      view_label: "Ventes"
      group_label: "Année N"
    }


  measure: sum_livraison_select_mois {
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${tarif_ht_livraison}
          END ;;
    view_label: "Web"
    group_label: "Année N"
  }

    measure: sum_total_ht_select_mois {
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${total_ht}
          END ;;
      view_label: "Web"
      group_label: "Année N"
    }

  measure: sum_CA_drive_select_mois {
    type: number
    value_format_name: eur
    label: "CA Drive"
    sql: ${sum_total_ht_select_mois} + ${sum_livraison_select_mois} ;;
    view_label: "Web"
    group_label: "Année N"
  }

    measure: sum_Nb_cde_drive_select_mois {
      type: sum
      value_format_name: decimal_0
      label: "Commande Drive"
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nbre_commande}
          END ;;
      view_label: "Web"
      group_label: "Année N"
    }

    measure: sum_surf_select_mois {
      type: average
      sql: ${surface};;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: ecarts_jour_select_mois {
      label: "écart jr"
      type: number
      sql:  ${sum_nb_jour_select_mois}-${sum_nb_jour_select_mois_N1} ;;
      view_label: "Ventes"
      group_label: "Année N"
    }


    ############ calcul des KPIs à n-1 de la période sélectionnée au niveau du filtre ###############



    measure: sum_CA_select_mois_N1 {
      label: "CA HT n-1"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: sum_marge_select_mois_N1 {
      hidden: no
      label: "Marge n-1"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: sum_nb_ticket_select_mois_N1 {
      hidden: no
      label: "Nb clts n-1"
      type: sum
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nb_ticket}
          END ;;
      view_label: "Clients"
      group_label: "Année N-1"
    }

    measure: sum_nb_jour_select_mois_N1 {
      hidden: no
      label: "Nb jr n-1"
      type: count_distinct
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: sum_val_achat_gbl_select_mois_N1 {
      hidden: yes
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }


  measure: sum_livraison_select_mois_N1 {
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)   {% endcondition %}
            THEN ${tarif_ht_livraison}
          END ;;
    view_label: "Web"
    group_label: "Année N-1"
  }


  measure: sum_total_ht_select_mois_N1 {
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)   {% endcondition %}
            THEN ${total_ht}
          END ;;
    view_label: "Web"
    group_label: "Année N-1"
  }

    measure: sum_CA_drive_select_mois_N1 {
      type: number
      value_format_name: eur
      label: "CA Drive n-1"
      sql: ${sum_total_ht_select_mois_N1} + ${sum_livraison_select_mois_N1} ;;
      view_label: "Web"
      group_label: "Année N-1"
    }

    measure: sum_Nb_cde_drive_select_mois_N1 {
      type: sum
      value_format_name: decimal_0
      label: "Commande Drive n-1"
      sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nbre_commande}
          END ;;
      view_label: "Web"
      group_label: "Année N-1"
    }

    ############## calcul des KPIs à n-2 de la période sélectionnée au niveau du filtre ##############


    measure: sum_CA_select_mois_N2 {
      hidden: no
      label: "CA HT n-2"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: sum_marge_select_mois_N2 {
      hidden: no
      label: "Marge n-2"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: sum_nb_ticket_select_mois_N2 {
      hidden: no
      label: "Nb clts n-2"
      type: sum
      value_format_name: decimal_0
      sql: CASE
           WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nb_ticket}
          END ;;
      view_label: "Clients"
      group_label: "Année N-2"
    }

    measure: sum_nb_jour_select_mois_N2 {
      hidden: no
      label: "Nb jr n-2"
      type: count_distinct
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: sum_val_achat_gbl_select_mois_N2 {
      hidden: yes
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

  measure: sum_livraison_select_mois_N2 {
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${tarif_ht_livraison}
          END ;;
    view_label: "Web"
    group_label: "Année N-2"
  }

  measure: sum_total_ht_select_mois_N2 {
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${total_ht}
          END ;;
    view_label: "Web"
    group_label: "Année N-2"
  }

    measure: sum_CA_drive_select_mois_N2 {
      hidden: no
      type: number
      value_format_name: eur
      label: "CA Drive n-2"
      sql: ${sum_total_ht_select_mois_N2} + ${sum_livraison_select_mois_N2} ;;
      view_label: "Web"
      group_label: "Année N-2"
    }

    measure: sum_Nb_cde_drive_select_mois_N2 {
      hidden: no
      type: sum
      value_format_name: decimal_0
      label: "Commande Drive n-2"
      sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)   {% endcondition %}
            THEN ${nbre_commande}
          END ;;
      view_label: "Web"
      group_label: "Année N-2"
    }


    ############ calcul des KPIs à n-3 de la période sélectionnée au niveau du filtre ###############


    measure: sum_CA_select_mois_N3 {
      hidden: no
      label: "CA HT n-3"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }

    measure: sum_marge_select_mois_N3 {
      hidden: no
      label: "Marge n-3"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }

    measure: sum_nb_ticket_select_mois_N3 {
      hidden: no
      label: "Nb clts n-3"
      type: sum
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nb_ticket}
          END ;;
      view_label: "Clients"
      group_label: "Année N-3"
    }

    measure: sum_nb_jour_select_mois_N3 {
      hidden: yes
      label: "Nb jr n-3"
      type: count_distinct
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }

    measure: sum_val_achat_gbl_select_mois_N3 {
      hidden: yes
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }


    ######### calcul des rapports entre les KPIs à la période n sélectionnée au niveau du filtre  ##########


    measure: client_par_jour_select_mois {
      label: "clts / jour"
      value_format_name: decimal_0
      type: number
      sql: ${sum_nb_ticket_select_mois}/NULLIF(${sum_nb_jour_select_mois},0) ;;
      view_label: "Clients"
      group_label: "Année N"
    }

    measure: ca_par_jour_select_mois {
      label: "CA / jour"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois}/NULLIF(${sum_nb_jour_select_mois},0) ;;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: ca_par_m_carre_select_mois {
      label: "CA / m²"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois}/NULLIF(${sum_surf_select_mois},0) ;;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: taux_de_marge_select_mois {
      label: "% marge"
      value_format_name: percent_2
      type: number
      sql: 1.0 * ${sum_marge_select_mois}/NULLIF(${sum_CA_select_mois},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: panier_moyen_select_mois {
      label: "PM"
      value_format_name: decimal_2
      type: number
      sql:  ${sum_CA_select_mois}/NULLIF(${sum_nb_ticket_select_mois},0) ;;
      view_label: "Panier Moyen"
      group_label: "Année N"
    }

    measure: panier_moyen_drive_select_mois {
      label: "PM Drive"
      value_format_name: decimal_2
      type: number
      sql:  ${sum_CA_drive_select_mois}/NULLIF(${sum_Nb_cde_drive_select_mois},0) ;;
      view_label: "Panier Moyen"
      group_label: "Année N"
    }

    measure: marge_par_client_select_mois {
      label: "marge / clts"
      value_format_name: decimal_2
      type: number
      sql: ${sum_marge_select_mois}/NULLIF(${sum_nb_ticket_select_mois},0) ;;
      view_label: "Ventes"
      group_label: "Année N"
    }


    ######### calcul des rapports entre les KPIs à la période n-1 sélectionnée au niveau du filtre  ##########

    measure: client_par_jour_select_mois_N1 {
      label: "clts/jr n-1"
      value_format_name: decimal_0
      type: number
      sql: ${sum_nb_ticket_select_mois_N1}/NULLIF(${sum_nb_jour_select_mois_N1},0) ;;
      drill_fields: [detail*]
      view_label: "Clients"
      group_label: "Année N-1"
    }

    measure: ca_par_jour_select_mois_N1 {
      hidden: no
      label: "CA/jr n-1"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois_N1}/NULLIF(${sum_nb_jour_select_mois_N1},0) ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: ca_par_m_carre_select_mois_N1 {
      label: "CA/m² n-1"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois_N1}/NULLIF(${sum_surf_select_mois},0) ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: taux_de_marge_select_mois_N1 {
      hidden: no
      label: "% marge n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * ${sum_marge_select_mois_N1}/NULLIF(${sum_CA_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: panier_moyen_select_mois_N1 {
      hidden: no
      label: "PM n-1"
      value_format_name: decimal_2
      type: number
      sql:  ${sum_CA_select_mois_N1}/NULLIF(${sum_nb_ticket_select_mois_N1},0) ;;
      view_label: "Panier Moyen"
      group_label: "Année N-1"
    }

    measure: marge_par_client_select_mois_N1 {
      label: "marge/clts n-1"
      value_format_name: decimal_2
      type: number
      sql: ${sum_marge_select_mois_N1}/NULLIF(${sum_nb_ticket_select_mois_N1},0) ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }



    ######### calcul des rapports entre les KPIs à la période n-2 sélectionnée au niveau du filtre  ##########


    measure: client_par_jour_select_mois_N2 {
      hidden: no
      label: "clts/jr n-2"
      value_format_name: decimal_0
      type: number
      sql: ${sum_nb_ticket_select_mois_N2}/NULLIF(${sum_nb_jour_select_mois_N2},0) ;;
      view_label: "Clients"
      group_label: "Année N-2"
    }

    measure: ca_par_jour_select_mois_N2 {
      hidden: no
      label: "CA/jr n-2"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois_N2}/NULLIF(${sum_nb_jour_select_mois_N2},0) ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: ca_par_m_carre_select_mois_N2 {
      hidden: no
      label: "CA/m² n-2"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois_N2}/NULLIF(${sum_surf_select_mois},0) ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: taux_de_marge_select_mois_N2 {
      hidden: no
      label: "% marge n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * ${sum_marge_select_mois_N2}/NULLIF(${sum_CA_select_mois_N2},0);;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: panier_moyen_select_mois_N2 {
      hidden: no
      label: "PM n-2"
      value_format_name: decimal_2
      type: number
      sql:  ${sum_CA_select_mois_N2}/NULLIF(${sum_nb_ticket_select_mois_N2},0) ;;
      view_label: "Panier Moyen"
      group_label: "Année N-2"
    }

    measure: marge_par_client_select_mois_N2 {
      hidden: no
      label: "marge/clts n-2"
      value_format_name: decimal_2
      type: number
      sql: ${sum_marge_select_mois_N2}/NULLIF(${sum_nb_ticket_select_mois_N2},0) ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }



    ######### calcul des rapports entre les KPIs à la période n-3 sélectionnée au niveau du filtre  ##########


    measure: client_par_jour_select_mois_N3 {
      hidden: no
      label: "clts/jr n-3"
      value_format_name: decimal_0
      type: number
      sql: ${sum_nb_ticket_select_mois_N3}/NULLIF(${sum_nb_jour_select_mois_N3},0) ;;
      view_label: "Clients"
      group_label: "Année N-3"
    }

    measure: ca_par_jour_select_mois_N3 {
      hidden: no
      label: "CA/jr n-3"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois_N3}/NULLIF(${sum_nb_jour_select_mois_N3},0) ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }

    measure: ca_par_m_carre_select_mois_N3 {
      hidden: no
      label: "CA/m² n-3"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois_N3}/NULLIF(${sum_surf_select_mois},0) ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }

    measure: taux_de_marge_select_mois_N3 {
      hidden: no
      label: "% marge n-3"
      value_format_name: percent_2
      type: number
      sql: 1.0 * ${sum_marge_select_mois_N3}/NULLIF(${sum_CA_select_mois_N3},0);;
      view_label: "Ventes"
      group_label: "Année N-3"
    }

    measure: panier_moyen_select_mois_N3 {
      hidden: no
      label: "PM n-3"
      value_format_name: decimal_2
      type: number
      sql:  ${sum_CA_select_mois_N3}/NULLIF(${sum_nb_ticket_select_mois_N3},0) ;;
      view_label: "Panier Moyen"
      group_label: "Année N-3"
    }

    measure: marge_par_client_select_mois_N3 {
      hidden: no
      label: "marge/clts n-3"
      value_format_name: decimal_2
      type: number
      sql: ${sum_marge_select_mois_N3}/NULLIF(${sum_nb_ticket_select_mois_N3},0) ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }


    ########### Calcul des progressions n vs n-1 à la péridode sélectionée au niveau du filtre ###########


    measure: prog_CA_select_mois {
      label: "prog CA"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_CA_select_mois}-${sum_CA_select_mois_N1})/NULLIF(${sum_CA_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: prog_CA_Drive_select_mois {
      label: "prog CA Drive"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_CA_drive_select_mois}-${sum_CA_drive_select_mois_N1})/NULLIF(${sum_CA_drive_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: prog_marge_select_mois {
      label: "prog marge"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${sum_marge_select_mois}-${sum_marge_select_mois_N1})/NULLIF(${sum_marge_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: prog_taux_marge_select_mois {
      label: "prog %marge"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${taux_de_marge_select_mois}-${taux_de_marge_select_mois_N1})/NULLIF(${taux_de_marge_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: prog_ca_par_m_carre_select_mois {
      label: "prog CA/m²"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${ca_par_m_carre_select_mois}-${ca_par_m_carre_select_mois_N1})/NULLIF(${ca_par_m_carre_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: prog_Clients_select_mois {
      label: "prog clts/jr"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${client_par_jour_select_mois}-${client_par_jour_select_mois_N1})/NULLIF(${client_par_jour_select_mois_N1},0) ;;
      view_label: "Clients"
      group_label: "Année N"
    }

    measure: prog_nb_Clients_select_mois {
      label: "prog nb clts"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_nb_ticket_select_mois}-${sum_nb_ticket_select_mois_N1})/NULLIF(${sum_nb_ticket_select_mois_N1},0) ;;
      view_label: "Clients"
      group_label: "Année N"
    }

    measure: prog_ca_jour_select_mois {
      label: "prog CA / jr"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${ca_par_jour_select_mois}-${ca_par_jour_select_mois_N1})/NULLIF(${ca_par_jour_select_mois_N1},0) ;;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: prog_PM_select_mois {
      label: "prog PM"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${panier_moyen_select_mois}-${panier_moyen_select_mois_N1})/(NULLIF(${panier_moyen_select_mois_N1},0));;
      view_label: "Panier Moyen"
      group_label: "Année N"
    }

    measure: prog_marge_client_select_mois {
      label: "prog marge/clt"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${marge_par_client_select_mois}-${marge_par_client_select_mois_N1})/NULLIF(${marge_par_client_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }



    ######### Calcul des progressions n-1 vs n-2 à la péridode sélectionée au niveau du filtre #########

    measure:prog_ca_select_mois_N1 {
      label: "prog CA n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_CA_select_mois_N1}-${sum_CA_select_mois_N2})/NULLIF(${sum_CA_select_mois_N2},0);;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: prog_marge_select_mois_N1 {
      hidden: no
      label: "prog marge n-1"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${sum_marge_select_mois_N1}-${sum_marge_select_mois_N2})/NULLIF(${sum_marge_select_mois_N2},0);;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: prog_ca_par_m_carre_select_mois_N1 {
      hidden: no
      label: "prog CA/m² n-1"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${ca_par_m_carre_select_mois_N1}-${ca_par_m_carre_select_mois_N2})/NULLIF(${ca_par_m_carre_select_mois_N2},0);;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: prog_nb_Clients_select_mois_N1 {
      hidden: no
      label: "prog nb clts n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_nb_ticket_select_mois_N1}-${sum_nb_ticket_select_mois_N2})/NULLIF(${sum_nb_ticket_select_mois_N2},0) ;;
      view_label: "Clients"
      group_label: "Année N-1"
    }

    measure: prog_taux_marge_select_mois_N1 {
      hidden: no
      label: "prog %marge n-1"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${taux_de_marge_select_mois_N1}-${taux_de_marge_select_mois_N2})/NULLIF(${taux_de_marge_select_mois_N2},0);;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: prog_Clients_select_mois_N1 {
      hidden: no
      label: "prog clts/jr n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${client_par_jour_select_mois_N1}-${client_par_jour_select_mois_N2})/NULLIF(${client_par_jour_select_mois_N2},0) ;;
      view_label: "Clients"
      group_label: "Année N-1"
    }

    measure: prog_ca_jour_select_mois_N1 {
      hidden: no
      label: "prog CA/jr n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${ca_par_jour_select_mois_N1}-${ca_par_jour_select_mois_N2})/NULLIF(${ca_par_jour_select_mois_N2},0) ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: prog_PM_select_mois_N1 {
      hidden: no
      label: "prog PM n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${panier_moyen_select_mois_N1}-${panier_moyen_select_mois_N2})/(NULLIF(${panier_moyen_select_mois_N2},0));;
      view_label: "Panier Moyen"
      group_label: "Année N-1"
    }

    measure: prog_marge_client_select_mois_N1 {
      hidden: no
      label: "prog marge/clt n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${marge_par_client_select_mois_N1}-${marge_par_client_select_mois_N2})/NULLIF(${marge_par_client_select_mois_N2},0);;
      view_label: "Ventes"
      group_label: "Année N-1"
    }


    ######### Calcul des progressions n-2 vs n-3 à la péridode sélectionée au niveau du filtre #########

    measure:prog_ca_select_mois_N2 {
      hidden: no
      label: "prog CA n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_CA_select_mois_N2}-${sum_CA_select_mois_N3})/NULLIF(${sum_CA_select_mois_N3},0);;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: prog_marge_select_mois_N2 {
      hidden: no
      label: "prog marge n-2"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${sum_marge_select_mois_N2}-${sum_marge_select_mois_N3})/NULLIF(${sum_marge_select_mois_N3},0);;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: prog_ca_par_m_carre_select_mois_N2 {
      hidden: no
      label: "prog CA/m² n-2"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${ca_par_m_carre_select_mois_N2}-${ca_par_m_carre_select_mois_N3})/NULLIF(${ca_par_m_carre_select_mois_N3},0);;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: prog_taux_marge_select_mois_N2 {
      hidden: no
      label: "prog %marge n-2"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${taux_de_marge_select_mois_N2}-${taux_de_marge_select_mois_N3})/NULLIF(${taux_de_marge_select_mois_N3},0);;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: prog_Clients_select_mois_N2 {
      hidden: no
      label: "prog clts/jr n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${client_par_jour_select_mois_N2}-${client_par_jour_select_mois_N3})/NULLIF(${client_par_jour_select_mois_N3},0) ;;
      view_label: "Clients"
      group_label: "Année N-2"
    }

    measure: prog_nb_Clients_select_mois_N2 {
      hidden: no
      label: "prog nb clts n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_nb_ticket_select_mois_N2}-${sum_nb_ticket_select_mois_N3})/NULLIF(${sum_nb_ticket_select_mois_N3},0) ;;
      view_label: "Clients"
      group_label: "Année N-2"
    }

    measure: prog_ca_jour_select_mois_N2 {
      hidden: no
      label: "prog CA/jr n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${ca_par_jour_select_mois_N2}-${ca_par_jour_select_mois_N3})/NULLIF(${ca_par_jour_select_mois_N3},0) ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: prog_PM_select_mois_N2 {
      hidden: no
      label: "prog PM n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${panier_moyen_select_mois_N2}-${panier_moyen_select_mois_N3})/(NULLIF(${panier_moyen_select_mois_N3},0));;
      view_label: "Panier Moyen"
      group_label: "Année N-2"
    }

    measure: prog_marge_client_select_mois_N2 {
      hidden: no
      label: "prog marge/clt n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${marge_par_client_select_mois_N2}-${marge_par_client_select_mois_N3})/NULLIF(${marge_par_client_select_mois_N3},0);;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

  }
