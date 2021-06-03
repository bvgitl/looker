view: pdt_famille {
  derived_table: {
    sql: SELECT distinct
       a.LibArticle as designation,
       a.STATUT_ART as Statut_article,
       a.TYP_ARTICLE as Typ_article,
       a.CLASS_ENERGIE as Note_ecologique,
       a.Gencod as Gencode,
       n4.Niveau4 as Niveau_4,
       n3.SousFamille as N3_SS_Famille,
       n2.Famille as N2_Famille,
       n1.Division as N1_Division,
       m.Nom_TBE as NOM,
       m.Type_TBE as Typ ,
       m.DATE_OUV as Dte_Ouverture,
       m.Pays_TBE as Pays ,
       m.Animateur as Animateur,
       m.Region as Region ,
       m.SURF_VTE as Surface ,
       m.TYP_MAG as TYP_MAG,
       m.Tranche_age as Anciennete,
       m.CD_Magasin as CD_Magasin,
       v.CD_Article as Article,
       v.Dte_Vte as Dte_Vte,
       v.Typ_Vente as Typ_Vente ,
       v.Qtite as Qtite,
       v.ca_ht as ca_ht,
       v.marge_brute as marge_brute,
       mag.nb_ticket as nb_ticket,
       mq.LB_MARQUE as Marque,
       f.l_Fournisseur as Fournisseur,
       t.Qte_tracts as Qte_tracts,
       t.Mise_en_avant_web as web,
       t.E_mail as E_mail,
       t.SMS as SMS,
       t.Booster_Bonial as Booster_Bonial,
       t.Spot_RadioShop as Spot_RadioShop,
       t.PLV_Moyen_Kit as PLV_Moyen_Kit,
       t.PLV_Grand_Kit as PLV_Grand_Kit,
       s.stock as stock

FROM  (

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
group by 1,2,3,4) v


LEFT JOIN


(
    select
    RIGHT(CONCAT('000', CD_Site_Ext),3)  as CD_Site_Ext ,
    Dte_Vte,
    Typ_vente,
    sum(nb_ticket) as nb_ticket
    from `bv-prod.Matillion_Perm_Table.TF_VENTE_MAG`
    group by 1,2,3
  ) mag

  ON  v.CD_Site_Ext = mag.CD_Site_Ext

  AND  v.Dte_Vte = mag.Dte_Vte

  AND v.Typ_vente = mag.Typ_vente )

LEFT JOIN   `bv-prod.Matillion_Perm_Table.Magasins` m

ON   v.CD_Site_Ext = m.cd_logiciel

LEFT JOIN  `bv-prod.Matillion_Perm_Table.ARTICLE` a

ON  v.CD_Article = a.ID_ARTICLE_TFVTE

LEFT JOIN `bv-prod.Matillion_Perm_Table.ARTICLE_ARBO` art

ON CAST(v.CD_Article as INT64) = art.ID_ARTICLE

LEFT JOIN `bv-prod.Matillion_Perm_Table.N4`  n4

ON art.ID_N4_N4 = n4.ID_N4_N4

LEFT JOIN `bv-prod.Matillion_Perm_Table.N3_SS_Famille` n3

ON  n4.ID_N3_SSFAMILLE = n3.ID_N3_SSFAMILLE

LEFT JOIN `bv-prod.Matillion_Perm_Table.N2_Famille` n2

ON  n3.ID_N2_FAMILLE = n2.ID_N2_FAMILLE

LEFT JOIN `bv-prod.Matillion_Perm_Table.N1_Division` n1

ON  n2.ID_N1_DIVISION = n1.ID_N1_DIVISION

LEFT JOIN  `bv-prod.Matillion_Perm_Table.Marques` mq

ON a.ID_MARQUE = mq.cd_marque

LEFT JOIN `bv-prod.Matillion_Perm_Table.FOUR_DWH` f

ON   a.ID_FOURN = CAST(f.c_fournisseur AS STRING)

LEFT JOIN

(
        SELECT
               code_bv,
               Mise_en_avant_web,
               E_mail,
               SMS,
               Booster_Bonial,
               Spot_RadioShop,
               PLV_Moyen_Kit,
               PLV_Grand_Kit,
               sum(Qt_tracts) as Qte_tracts
               FROM `bv-prod.Matillion_Temp_Table.TRACTS`
               GROUP BY 1,2,3,4,5,6,7,8 ) t
ON  m.cd_magasin = t.code_bv

LEFT JOIN
(
        select
               cd_externe,
               cd_article,
               CAST(DATETIME_TRUNC(date_modification, day) AS date) dte_stock,
               sum(n_stock) as stock
FROM `bv-prod.Matillion_Perm_Table.Stocks`
group by 1,2,3
) s

ON  v.CD_Site_Ext = s.cd_externe

AND  v.CD_Article  = s.cd_article

AND v.Dte_vte = s.dte_stock
 ;;

    persist_for: "24 hours"
  }


  dimension: designation {
    type: string
    sql: ${TABLE}.designation ;;
  }

  dimension: statut_article {
    type: string
    sql: ${TABLE}.Statut_article ;;
  }

  dimension: typ_article {
    type: string
    sql: ${TABLE}.Typ_article ;;
  }

  dimension: note_ecologique {
    type: string
    sql: ${TABLE}.Note_ecologique ;;
  }

  dimension: gencode {
    type: string
    sql: ${TABLE}.Gencode ;;
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

  dimension: dte_ouverture {
    type: date
    datatype: date
    sql: ${TABLE}.Dte_Ouverture ;;
  }

  dimension: pays {
    type: string
    sql: ${TABLE}.Pays ;;
  }

  dimension: animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
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

  dimension: article {
    type: string
    sql: ${TABLE}.Article ;;
  }

  dimension: dte_vte {
    type: date
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

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.nb_ticket ;;
  }

  dimension: marque {
    type: string
    sql: ${TABLE}.Marque ;;
  }

  dimension: fournisseur {
    type: string
    sql: ${TABLE}.Fournisseur ;;
  }

  dimension: qte_tracts {
    type: number
    sql: ${TABLE}.Qte_tracts ;;
  }

  dimension: web {
    type: number
    sql: ${TABLE}.web ;;
  }

  dimension: e_mail {
    type: number
    sql: ${TABLE}.E_mail ;;
  }

  dimension: sms {
    type: number
    sql: ${TABLE}.SMS ;;
  }

  dimension: booster_bonial {
    type: number
    sql: ${TABLE}.Booster_Bonial ;;
  }

  dimension: spot_radio_shop {
    type: number
    sql: ${TABLE}.Spot_RadioShop ;;
  }

  dimension: plv_moyen_kit {
    type: number
    sql: ${TABLE}.PLV_Moyen_Kit ;;
  }

  dimension: plv_grand_kit {
    type: number
    sql: ${TABLE}.PLV_Grand_Kit ;;
  }

  dimension: stock {
    type: number
    sql: ${TABLE}.stock ;;
  }

  set: detail {
    fields: [
      designation,
      statut_article,
      typ_article,
      note_ecologique,
      gencode,
      niveau_4,
      n3_ss_famille,
      n2_famille,
      n1_division,
      nom,
      typ,
      dte_ouverture,
      pays,
      animateur,
      region,
      surface,
      typ_mag,
      anciennete,
      cd_magasin,
      article,
      dte_vte,
      typ_vente,
      qtite,
      ca_ht,
      marge_brute,
      nb_ticket,
      marque,
      fournisseur,
      qte_tracts,
      web,
      e_mail,
      sms,
      booster_bonial,
      spot_radio_shop,
      plv_moyen_kit,
      plv_grand_kit,
      stock
    ]
  }


  # dimension: note_ecologique {
  #   type: string
  #   sql: ${TABLE}.Note_ecologique ;;
  #   html: {% if value == "B" %}
  #         <p style="color: black; background-color: lime; font-size: 100%;"><B>{{ value }}</B></p>
  #         {% elsif value == "C" %}
  #         <p style="color: black;  background-color: yellow; font-size: 100%;"><B>{{ value }}</B></p>
  #         {% elsif value == "A" %}
  #         <p style="color: black; background-color: limegreen; font-size: 100%;"><B>{{ value }}</B></p>
  #         {% elsif value == "D" %}
  #         <p style="color: black; background-color: gold; font-size: 100%;"><B>{{ value }}</B></p>
  #         {% elsif value == "X" %}
  #         <p style="color: black; background-color: red; font-size: 100%;"><B>{{ value }}</B></p>
  #         {% else %}
  #         <p style="color: black; background-color: tomato; font-size: 100%;"><B>{{ value }}</B></p>
  #   {% endif %};;
  # }

  # dimension: origine {
  #   type: number
  #   sql: CASE
  #         WHEN ${TABLE}.Origine = 5 THEN "France"
  #         WHEN ${TABLE}.Origine = 6 THEN "Union Européenne"
  #         WHEN ${TABLE}.Origine = 7 THEN "Reste du monde"
  #         WHEN ${TABLE}.Origine = 8 THEN "Non renseigné"
  #         END;;
  # }

  # dimension: statut_article {
  #   type: number
  #   sql: CASE
  #         WHEN ${TABLE}.Statut_article = 1 THEN "Actif"
  #         WHEN ${TABLE}.Statut_article = 5 THEN "Déférencé"
  #         END;;
  # }


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

  dimension: Type_MEP {
    sql: CASE
            WHEN ${typ} IN ("I","Cyi") THEN "MEP"
          END ;;
  }

  dimension: Type_City {
    sql: CASE
            WHEN ${typ} IN ("Cyi", "Cyf") THEN "City"
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


  # measure: sum_livraison_select_mois {
  #   type: sum
  #   value_format_name: eur
  #   sql: CASE
  #           WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
  #           THEN ${tarif_ht_livraison}
  #         END ;;
  # }

  # measure: sum_tarif_produit_select_mois {
  #   type: sum
  #   value_format_name: eur
  #   sql: CASE
  #           WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
  #           THEN ${tarif_produit_ht}
  #         END ;;
  # }

  # measure: sum_total_ht_select_mois {
  #   type: sum
  #   value_format_name: eur
  #   sql: CASE
  #           WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
  #           THEN ${total_ht}
  #         END ;;
  # }

  # measure: valeur_drive {
  #   type: number
  #   label: "Valeur Drive"
  #   value_format_name: decimal_2
  #   sql: (${sum_total_ht_select_mois} * ${taux_de_marge_drive_select_mois}) + ${sum_livraison_select_mois};;
  # }

  # measure: taux_de_marge_drive_select_mois {
  #   label: "% marge drive"
  #   value_format_name: percent_2
  #   type: number
  #   sql: 1.0 * ${sum_marge_select_mois}/NULLIF(${sum_tarif_produit_select_mois},0);;
  # }


  # measure: sum_CA_drive_select_mois {
  #   type: number
  #   value_format_name: eur
  #   label: "CA Drive"
  #   sql: ${sum_total_ht_select_mois} + ${sum_livraison_select_mois} ;;
  # }

  # measure: sum_Nb_cde_drive_select_mois {
  #   type: sum
  #   value_format_name: decimal_0
  #   label: "Commande Drive"
  #   sql: CASE
  #           WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
  #           THEN ${nbre_commande}
  #         END ;;
  # }

  measure: DN_N {
    type: count_distinct
    value_format_name: decimal_0
    label: "DN"
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${article}
          END ;;
  }


  measure: stock_N {
    type: sum
    value_format_name: decimal_0
    label: "Stocks"
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${stock}
          END ;;
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

  # measure: sum_tarif_produit_select_mois_N1 {
  #   type: sum
  #   value_format_name: eur
  #   sql: CASE
  #           WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
  #           THEN ${tarif_produit_ht}
  #         END ;;
  # }

  measure: sum_nb_jour_select_mois_N1 {
    label: "Nb jr n-1"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
  }


  # measure: valeur_drive_N1 {
  #   type: number
  #   label: "Valeur Drive n-1"
  #   value_format_name: decimal_2
  #   sql: (${sum_total_ht_select_mois_N1} * ${taux_de_marge_drive_select_mois_N1}) + ${sum_livraison_select_mois_N1};;
  # }


  # measure: taux_de_marge_drive_select_mois_N1 {
  #   label: "% marge drive n-1"
  #   value_format_name: percent_2
  #   type: number
  #   sql: 1.0 * ${sum_marge_select_mois_N1}/NULLIF(${sum_tarif_produit_select_mois_N1},0);;
  # }


  # measure: sum_livraison_select_mois_N1 {
  #   type: sum
  #   value_format_name: eur
  #   sql: CASE
  #           WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)   {% endcondition %}
  #           THEN ${tarif_ht_livraison}
  #         END ;;
  # }


  # measure: sum_total_ht_select_mois_N1 {
  #   type: sum
  #   value_format_name: eur
  #   sql: CASE
  #           WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)   {% endcondition %}
  #           THEN ${total_ht}
  #         END ;;
  # }

  # measure: sum_CA_drive_select_mois_N1 {
  #   type: number
  #   value_format_name: eur
  #   label: "CA Drive n-1"
  #   sql: ${sum_total_ht_select_mois_N1} + ${sum_livraison_select_mois_N1} ;;
  # }

  # measure: sum_Nb_cde_drive_select_mois_N1 {
  #   type: sum
  #   value_format_name: decimal_0
  #   label: "Commande Drive n-1"
  #   sql: CASE
  #           WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
  #           THEN ${nbre_commande}
  #         END ;;
  # }

  measure: DN_N1 {
    type: count_distinct
    value_format_name: decimal_0
    label: "DN n-1"
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${article}
          END ;;
  }

  measure: stock_N1 {
    type: sum
    value_format_name: decimal_0
    label: "stocks n-1"
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${stock}
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

  # measure: prog_CA_Drive_select_mois {
  #   label: "prog CA Drive"
  #   value_format_name: percent_2
  #   type: number
  #   sql: 1.0 * (${sum_CA_drive_select_mois}-${sum_CA_drive_select_mois_N1})/NULLIF(${sum_CA_drive_select_mois_N1},0);;
  # }


  # measure: prog_Nb_cde_Drive_select_mois {
  #   label: "prog Nb cde Drive"
  #   value_format_name: percent_2
  #   type: number
  #   sql: 1.0 * (${sum_Nb_cde_drive_select_mois}-${sum_Nb_cde_drive_select_mois_N1})/NULLIF(${sum_Nb_cde_drive_select_mois_N1},0);;
  # }






}
