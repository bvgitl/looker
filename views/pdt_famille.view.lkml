view: pdt_famille {
  derived_table: {
    sql: SELECT distinct
       a.l_Article_long as designation,
       a.c_Type  as Typ_article,
       a.c_Note as Note_ecologique,
       a.c_Gencode as Gencode,
       a.c_Validite_1 as Statut_article,
       a.c_Origine as Origine,
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
       v.Val_Achat_Gbl as Val_Achat_Gbl,
       v.Dte_Vte as Dte_Vte,
       v.Typ_Vente as Typ_Vente ,
       v.Qtite as Qtite,
       v.ca_ht as ca_ht,
       v.marge_brute as marge_brute,
       mag.nb_ticket as nb_ticket,
       mq.LB_MARQUE as Marque,
       f.l_Fournisseur as Fournisseur,
       t.Qt_tracts as Qte_tracts,
       t.Mise_en_avant_web as web,
       t.E_mail as E_mail,
       t.SMS as SMS,
       t.Booster_Bonial as Booster_Bonial,
       t.Spot_RadioShop as Spot_RadioShop,
       t.PLV_Moyen_Kit as PLV_Moyen_Kit,
       t.PLV_Grand_Kit as PLV_Grand_Kit,
       s.stock as stock,
       w.Nbre_commande as Nbre_commande,
       w.Quantite_commandee as Quantite_commandee,
       w.Tarif_Produit_HT as Tarif_Produit_HT



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

LEFT JOIN  `bv-prod.Matillion_Perm_Table.ARTICLE_DWH` a

ON  v.CD_Article = a.c_Article

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

ON a.c_Marque = mq.cd_marque

LEFT JOIN `bv-prod.Matillion_Perm_Table.FOUR_DWH` f

ON   a.c_Fournisseur = CAST(f.c_fournisseur AS STRING)

LEFT JOIN `bv-prod.Matillion_Temp_Table.TRACTS` t
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

FULL JOIN

(
    SELECT
      p.cd_produit as cd_produit,
      c.cd_magasin as cd_magasin,
      CAST(DATETIME_TRUNC(c.dte_commande, DAY) AS DATE) AS dte_cde,
      count(distinct(p.cd_commande)) as Nbre_commande ,
      sum(p.Quantite_commandee) as Quantite_commandee,
      sum(p.Tarif_Produit_HT) as Tarif_Produit_HT
      FROM `bv-prod.Matillion_Perm_Table.Produit_Commande` p
      INNER JOIN  `bv-prod.Matillion_Perm_Table.COMMANDES` c
      ON p.cd_commande = c.cd_commande
      group by 1,2,3
) w

ON v.CD_Article = w.cd_produit

AND v.Dte_vte = w.dte_cde

AND m.CD_Magasin = w.cd_magasin
 ;;

    persist_for: "24 hours"
  }


  dimension: designation {
    type: string
    sql: ${TABLE}.designation ;;
    view_label: "Article"
  }

  dimension: typ_article {
    type: string
    sql: ${TABLE}.Typ_article ;;
    view_label: "Article"
  }

  dimension: gencode {
    type: string
    sql: ${TABLE}.Gencode ;;
    view_label: "Article"
  }

  dimension: niveau_4 {
    type: string
    sql: ${TABLE}.Niveau_4 ;;
    view_label: "N4"
  }

  dimension: n3_ss_famille {
    type: string
    sql: ${TABLE}.N3_SS_Famille ;;
    view_label: "N3"
  }

  dimension: n2_famille {
    type: string
    sql: ${TABLE}.N2_Famille ;;
    view_label: "N2"
  }

  dimension: n1_division {
    type: string
    sql: ${TABLE}.N1_Division ;;
    view_label: "N1"
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

  dimension: animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
    view_label: "Magasins"
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
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

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
    view_label: "Magasins"
  }

  dimension: article {
    type: string
    sql: ${TABLE}.Article ;;
    view_label: "Article"
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.Typ_Vente ;;
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

  dimension: val_achat_gbl {
    type: number
    sql: ${TABLE}.Val_Achat_Gbl ;;
  }

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.nb_ticket ;;
    view_label: "Ventes"
  }

  dimension: marque {
    type: string
    sql: ${TABLE}.Marque ;;
    view_label: "Marque"
  }

  dimension: fournisseur {
    type: string
    sql: ${TABLE}.Fournisseur ;;
    view_label: "Fournisseur"
  }

  dimension: qte_tracts {
    type: number
    sql: ${TABLE}.Qte_tracts ;;
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

  dimension: stock {
    type: number
    sql: ${TABLE}.stock ;;
    view_label: "Stocks"
  }

  dimension: nbre_commande {
    type: number
    sql: ${TABLE}.Nbre_commande ;;
    view_label: "Web"
  }

  dimension: quantite_commandee {
    type: number
    sql: ${TABLE}.Quantite_commandee ;;
    view_label: "Web"
  }

  dimension: tarif_produit_ht {
    type: number
    sql: ${TABLE}.Tarif_Produit_HT ;;
    view_label: "Web"
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
      pays,
      animateur,
      region,
      surface,
      typ_mag,
      anciennete,
      cd_magasin,
      article,
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


  dimension: note_ecologique {
    type: string
    sql: ${TABLE}.Note_ecologique ;;
    html: {% if value == "B" %}
          <p style="color: black; background-color: lime; font-size: 100%;"><B>{{ value }}</B></p>
          {% elsif value == "C" %}
          <p style="color: black;  background-color: yellow; font-size: 100%;"><B>{{ value }}</B></p>
          {% elsif value == "A" %}
          <p style="color: black; background-color: limegreen; font-size: 100%;"><B>{{ value }}</B></p>
          {% elsif value == "D" %}
          <p style="color: black; background-color: gold; font-size: 100%;"><B>{{ value }}</B></p>
          {% elsif value == "X" %}
          <p style="color: black; background-color: red; font-size: 100%;"><B>{{ value }}</B></p>
          {% else %}
          <p style="color: black; background-color: tomato; font-size: 100%;"><B>{{ value }}</B></p>
    {% endif %};;
    view_label: "Article"
  }

  dimension: origine {
    type: number
    sql: CASE
          WHEN ${TABLE}.Origine = 5 THEN "France"
          WHEN ${TABLE}.Origine = 6 THEN "Union Européenne"
          WHEN ${TABLE}.Origine = 7 THEN "Reste du monde"
          WHEN ${TABLE}.Origine = 8 THEN "Non renseigné"
          END;;
    view_label: "Article"
  }

  dimension: statut_article {
    type: number
    sql: CASE
          WHEN ${TABLE}.Statut_article = 0 THEN "Création"
          WHEN ${TABLE}.Statut_article = 1 THEN "Actif"
          WHEN ${TABLE}.Statut_article = 5 THEN "Déférencé"
          END;;
    view_label: "Article"
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




  filter: date_filter {                 ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n"
    type: date
    view_label: "Ventes"
    group_label: "Année N"
  }

  filter: date_filter_1 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n-1"
    type: date
    view_label: "Ventes"
    group_label: "Année N-1"
  }

  filter: date_filter_2 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n-2"
    type: date
    view_label: "Ventes"
    group_label: "Année N-2"
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
    view_label: "Ventes"
  }


  dimension: Groupe_Region {
    sql: CASE
            WHEN ${region} IN ("RN","RNE", "RNW", "RRA", "RSE", "RSW") THEN "France Metro"
            WHEN ${region} IN ("BE", "CAM", "ESP", "IT", "MAL", "MAU", "TOM", "TUN") THEN "International"
          END ;;
    view_label: "Magasins"
  }

  dimension: Type_MEP {
    sql: CASE
            WHEN ${typ} IN ("I","Cyi") THEN "MEP"
          END ;;
    view_label: "Magasins"
  }

  dimension: Type_City {
    sql: CASE
            WHEN ${typ} IN ("Cyi", "Cyf") THEN "City"
          END ;;
    view_label: "Magasins"
  }


  dimension: Groupe_Laser {
    sql: CASE
            WHEN ${n2_famille} IN ("CARTOUCHE LASER ET COPIEUR", "CARTOUCHE LASER ET COPIEUR COMPATIBLE") THEN "Laser"
            WHEN ${n2_famille} IN ("CARTOUCHE JET D’ENCRE MARQUE", "CARTOUCHE JET D’ENCRE COMPATIBLE") THEN "JET D'ENCRE"
          END ;;
    view_label: "N2"
  }

  dimension: Groupe_Marq {
    sql: CASE
            WHEN ${n2_famille} IN ("CARTOUCHE LASER ET COPIEUR", "CARTOUCHE JET D’ENCRE MARQUE") THEN "Marques"
            WHEN ${n2_famille} IN ("CARTOUCHE LASER ET COPIEUR COMPATIBLE", "CARTOUCHE JET D’ENCRE COMPATIBLE") THEN "Compatible"
          END ;;
    view_label: "N2"
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

  measure: sum_stock_mois {
    type: sum
    value_format_name: eur
    label: "Stock"
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${stock}
          END ;;
    view_label: "Stocks"
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

  measure: taux_de_marge_select_mois {
    label: "% marge"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_mois}/NULLIF(${sum_CA_select_mois},0);;
    view_label: "Ventes"
    group_label: "Année N"
  }

  measure: sum_qte_select_mois {
    label: "Qte"
    type: sum
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${qtite}
          END ;;
    view_label: "Ventes"
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


  measure: sum_tarif_select_mois {
    label: "Tarif produit HT"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${tarif_produit_ht}
          END ;;
    view_label: "Web"
    group_label: "Année N"
  }

  measure: sum_total_qte_com_select_mois {
    label: "Qte commandée"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${quantite_commandee}
          END ;;
    view_label: "Web"
    group_label: "Année N"
  }

  measure: sum_total_ht_select_mois {
    label: "Total_HT"
    type: number
    sql: ${sum_tarif_select_mois} * ${sum_total_qte_com_select_mois} ;;
    view_label: "Web"
    group_label: "Année N"
  }

  measure: taux_de_marge_drive_select_mois {
    label: "% marge drive"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_mois}/NULLIF(${sum_total_ht_select_mois},0);;
    view_label: "Web"
    group_label: "Année N"
  }

  measure: DN_N {
    type: count_distinct
    value_format_name: decimal_0
    label: "DN"
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${cd_magasin}
          END ;;
    view_label: "Article"
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

  measure: sum_qte_select_mois_N1 {
    label: "Qte n-1"
    type: sum
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${qtite}
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
  }


  measure: sum_nb_jour_select_mois_N1 {
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


  measure: sum_tarif_select_mois_N1 {
    label: "Tarif Produit HT"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${tarif_produit_ht}
          END ;;
    view_label: "Web"
    group_label: "Année N-1"
  }

  measure: sum_total_qte_com_select_mois_N1 {
    label: "Quantité commandée"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${quantite_commandee}
          END ;;
    view_label: "Web"
    group_label: "Année N-1"
  }

  measure: sum_total_ht_select_mois_N1 {
    label: "Total HT"
    type: number
    sql: ${sum_tarif_select_mois_N1} * ${sum_total_qte_com_select_mois_N1} ;;
    view_label: "Web"
    group_label: "Année N-1"
  }

  measure: taux_de_marge_drive_select_mois_N1 {
    label: "% marge drive"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_mois_N1}/NULLIF(${sum_total_ht_select_mois_N1},0);;
    view_label: "Web"
    group_label: "Année N-1"
  }

  measure: DN_N1 {
    type: count_distinct
    value_format_name: decimal_0
    label: "DN n-1"
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${cd_magasin}
          END ;;
    view_label: "Article"
    group_label: "Année N-1"
  }


  ############ calcul des KPIs à n-1 de la période sélectionnée au niveau du filtre ###############



  measure: sum_CA_select_mois_N2 {
    label: "CA HT n-2"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
    view_label: "Ventes"
    group_label: "Année N-2"
  }

  measure: sum_marge_select_mois_N2 {
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

  measure: sum_qte_select_mois_N2 {
    label: "Qte n-2"
    type: sum
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${qtite}
          END ;;
    view_label: "Ventes"
    group_label: "Année N-2"
  }


  measure: sum_nb_jour_select_mois_N2 {
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


  measure: DN_N2 {
    type: count_distinct
    value_format_name: decimal_0
    label: "DN n-1"
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${article}
          END ;;
    view_label: "Article"
    group_label: "Année N-2"
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

  measure: prog_Qte_select_mois {
    label: "prog Qte"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_qte_select_mois}-${sum_qte_select_mois_N1})/NULLIF(${sum_qte_select_mois_N1},0);;
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

########### Calcul des progressions n vs n-1 à la péridode sélectionée au niveau du filtre ###########


  measure: prog_CA_select_mois_N {
    label: "prog CA n-1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_CA_select_mois}-${sum_CA_select_mois_N1})/NULLIF(${sum_CA_select_mois_N1},0);;
    view_label: "Ventes"
    group_label: "Année N-1"
  }

  measure: prog_Qte_select_mois_N {
    label: "prog Qte n-1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_qte_select_mois}-${sum_qte_select_mois_N1})/NULLIF(${sum_qte_select_mois_N1},0);;
    view_label: "Ventes"
    group_label: "Année N-1"
  }

  measure: prog_marge_select_mois_N {
    label: "prog marge n-1"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${sum_marge_select_mois}-${sum_marge_select_mois_N1})/NULLIF(${sum_marge_select_mois_N1},0);;
    view_label: "Ventes"
    group_label: "Année N-1"
  }



}
