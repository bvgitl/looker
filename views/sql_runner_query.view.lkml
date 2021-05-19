view: sql_runner_query {
  derived_table: {
    sql: SELECT distinct
       a.c_article as article,
       a.c_fournisseur as cd_fournisseur,
       a.c_marque as cd_marque,
       art.c_noeud as noeud,
       art.c_arbre as arbre,
       n4.Niveau4 as Niveau_4,
       n3.SousFamille as N3_SS_Famille,
       n2.Famille as N2_Famille,
       n1.Division as N1_Division,
       b.Nom_TBE as NOM,
       b.Type_TBE as Typ ,
       b.DATE_OUV as Dte_Ouverture,
       b.Pays_TBE as Pays ,
       b.Region as Region ,
       b.SURF_VTE as Surface ,
       b.TYP_MAG as TYP_MAG,
       b.Tranche_age as Anciennete,
       b.CD_Magasin as CD_Magasin,
       b.CD_Article,
       b.Dte_Vte as Dte_Vte,
       b.Typ_Vente as Typ_Vente ,
       b.Qtite as Qtite,
       b.ca_ht as ca_ht,
       b.marge_brute as marge_brute


FROM  (`bv-prod.Matillion_Perm_Table.ARTICLE_DWH` a

LEFT JOIN `bv-prod.Matillion_Perm_Table.ART_ARBO_DWH` art

ON art.c_article = a.c_Article

LEFT JOIN `bv-prod.Matillion_Perm_Table.N4`  n4

ON n4.ID_N4_N4 = art.c_noeud

LEFT JOIN `bv-prod.Matillion_Perm_Table.N3_SS_Famille` n3

ON n3.ID_N3_SSFAMILLE = n4.ID_N3_SSFAMILLE

LEFT JOIN `bv-prod.Matillion_Perm_Table.N2_Famille` n2

ON n2.ID_N2_FAMILLE = n3.ID_N2_FAMILLE

LEFT JOIN `bv-prod.Matillion_Perm_Table.N1_Division` n1

ON n1.ID_N1_DIVISION = n2.ID_N1_DIVISION)


LEFT JOIN  (

SELECT
       Nom_TBE,
       Type_TBE ,
       DATE_OUV,
       Pays_TBE,
       Region ,
       SURF_VTE,
       TYP_MAG ,
       Tranche_age ,
       CD_Magasin ,
       CD_Article,
       Dte_Vte ,
       Typ_Vente  ,
       Qtite ,
       ca_ht ,
       marge_brute


       FROM `bv-prod.Matillion_Perm_Table.Magasins` m

       LEFT JOIN

       (select
        RIGHT(CONCAT('000', CD_Site_Ext),3)  as CD_Site_Ext ,
        Dte_Vte ,
        Typ_Vente ,
        CD_Article,
        sum(Val_Achat_Gbl) as Val_Achat_Gbl ,
        sum(Qtite) as Qtite ,
        sum(ca_ht) as ca_ht ,
        sum(marge_brute) as marge_brute
      from `bv-prod.Matillion_Perm_Table.TF_VENTE`
      group by 1,2,3,4

      UNION ALL

select
        RIGHT(CONCAT('000', CD_SITE_EXT),3)  as CD_Site_Ext ,
        DTE_VENTE ,
        TYP_VENTE ,
        ID_ARTICLE,
        sum(VAL_ACHAT_GBL) as Val_Achat_Gbl ,
        sum(QTITE) as Qtite ,
        sum(CA_HT) as ca_ht,
        sum(MARGE_BRUTE) as marge_brute
      from `bv-prod.Matillion_Perm_Table.GOOGLE_SHEET`
      group by 1,2,3,4

      ) v

       ON m.cd_logiciel = v.CD_Site_Ext ) b


       ON b.CD_Article = a.c_Article

 ;;
    persist_for: "24 hours"
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: article {
    type: string
    sql: ${TABLE}.article ;;
  }

  dimension: cd_fournisseur {
    type: string
    sql: ${TABLE}.cd_fournisseur ;;
  }

  dimension: cd_marque {
    type: string
    sql: ${TABLE}.cd_marque ;;
  }

  dimension: arbre {
    type: number
    sql: ${TABLE}.arbre ;;
  }

  dimension: niveau_4 {
    type: string
    sql: ${TABLE}.Niveau_4 ;;
  }

  dimension: n3_ss_famille {
    type: string
    sql: ${TABLE}.N3_SS_Famille ;;
  }

  dimension: n2_famille {
    type: string
    sql: ${TABLE}.N2_Famille ;;
  }

  dimension: n1_division {
    type: string
    sql: ${TABLE}.N1_Division ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
  }

  dimension: typ {
    type: string
    sql: ${TABLE}.Typ ;;
  }

  dimension: pays {
    type: string
    sql: ${TABLE}.Pays ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
  }

  dimension: surface {
    type: number
    sql: ${TABLE}.Surface ;;
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
  }

  dimension: anciennete {
    type: string
    sql: ${TABLE}.Anciennete ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
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
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.Typ_Vente ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.Qtite ;;
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.ca_ht ;;
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.marge_brute ;;
  }

  set: detail {
    fields: [
      article,
      cd_fournisseur,
      cd_marque,
      arbre,
      niveau_4,
      n3_ss_famille,
      n2_famille,
      n1_division,
      nom,
      typ,
      pays,
      region,
      surface,
      typ_mag,
      anciennete,
      cd_magasin,
      typ_vente,
      qtite,
      ca_ht,
      marge_brute
    ]
  }



  filter: date_filter {                 ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n"
    type: date
  }

  filter: date_filter_1 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n-1"
    type: date
  }

  dimension: categorie {
    label: "Catégorie"
    sql:
        CASE
          WHEN ${typ} = "S"  OR
          ${dte_ouverture_date} > CAST ({% date_start date_filter_1 %} AS DATETIME) THEN "P. non Comparable"
          WHEN ${dte_ouverture_date} <= CAST ({% date_start date_filter_1 %} AS DATETIME) THEN "P.Comparable"
        END
    ;;
  }


  dimension: Type_retrocession {
    sql: CASE
            WHEN ${typ_vente} = 0 THEN "Hors rétrocession"
            ELSE "Rétrocession"
          END ;;
  }


  dimension: Groupe_Region {
    sql: CASE
            WHEN ${region} IN ("RN","RNE", "RNW", "RRA", "RSE", "RSW") THEN "France Metro"
            WHEN ${region} IN ("BE", "CAM", "ESP", "IT", "MAL", "MAU", "TOM", "TUN") THEN "International"
          END ;;
  }

  dimension: Groupe_Laser {
    sql: CASE
            WHEN ${n2_famille} IN ("CARTOUCHE LASER ET COPIEUR", "CARTOUCHE LASER ET COPIEUR COMPATIBLE") THEN "Laser"
            WHEN ${n2_famille} IN ("CARTOUCHE JET D’ENCRE MARQUE", "CARTOUCHE JET D’ENCRE COMPATIBLE") THEN "JET D'ENCRE"
          END ;;
  }

  dimension: Groupe_Marq {
    sql: CASE
            WHEN ${n2_famille} IN ("CARTOUCHE LASER ET COPIEUR", "CARTOUCHE JET D’ENCRE MARQUE") THEN "Marques"
            WHEN ${n2_famille} IN ("CARTOUCHE LASER ET COPIEUR COMPATIBLE", "CARTOUCHE JET D’ENCRE COMPATIBLE") THEN "Compatible"
          END ;;
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
  }

  measure: sum_marge_select_mois {
    label: "Marge"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
  }

  measure: taux_de_marge_select_mois {
    label: "% marge"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_mois}/NULLIF(${sum_CA_select_mois},0);;
  }

  measure: sum_qte_select_mois {
    label: "Qte"
    type: sum
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${qtite}
          END ;;
  }


  measure: sum_nb_jour_select_mois {
    label: "Nb jr"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
  }


  measure: sum_surf_select_mois {
    type: average
    sql: ${surface};;
  }

  measure: ecarts_jour_select_mois {
    label: "écart jr"
    type: number
    sql:  ${sum_nb_jour_select_mois}-${sum_nb_jour_select_mois_N1} ;;
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
  }

  measure: sum_marge_select_mois_N1 {
    label: "Marge n-1"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
  }

  measure: sum_qte_select_mois_N1 {
    label: "Qte n-1"
    type: sum
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${qtite}
          END ;;
  }



  measure: sum_nb_jour_select_mois_N1 {
    label: "Nb jr n-1"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
  }


########### Calcul des progressions n vs n-1 à la péridode sélectionée au niveau du filtre ###########


  measure: prog_CA_select_mois {
    label: "prog CA"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_CA_select_mois}-${sum_CA_select_mois_N1})/NULLIF(${sum_CA_select_mois_N1},0);;
  }

  measure: prog_Qte_select_mois {
    label: "prog Qte"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_qte_select_mois}-${sum_qte_select_mois_N1})/NULLIF(${sum_qte_select_mois_N1},0);;
  }

  measure: prog_marge_select_mois {
    label: "prog marge"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${sum_marge_select_mois}-${sum_marge_select_mois_N1})/NULLIF(${sum_marge_select_mois_N1},0);;
  }





}
