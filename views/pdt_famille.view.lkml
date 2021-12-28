view: pdt_famille {
  derived_table: {
    sql: SELECT distinct
       a.l_Article_long as designation,
       a.c_Type  as Typ_article,
       a.c_Note as Note_ecologique,
       a.c_Gencode as Gencode,
       a.c_Validite_1 as Statut_article,
       a.c_Origine as Origine,
       arb.N4 as Niveau_4,
       arb.N3_SousFamille as N3_SS_Famille,
       arb.N2_Famille as N2_Famille,
       arb.N1_Division as N1_Division,
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
       v.CD_Article_Original  AS ArticleOriginal,
       v.Val_Achat_Gbl as Val_Achat_Gbl,
       v.Dte_Vte as Dte_Vte,
       v.Typ_Vente as Typ_Vente ,
       v.Qtite as Qtite,
       v.ca_ht as ca_ht,
       v.marge_brute as marge_brute,
       mq.LB_MARQUE as Marque,
       f.l_Fournisseur as Fournisseur,
       s.n_stock as stock,
       w.Nbre_commande as Nbre_commande,
       w.Quantite_commandee as Quantite_commandee,
       w.Tarif_Produit_HT as Tarif_Produit_HT


FROM
(select
        CD_Magasin,
        Dte_Vte,
        Typ_Vente,
        CD_Article,
        CD_Article_Original,
        sum(Val_Achat_Gbl) as Val_Achat_Gbl ,
        sum(Qtite) as Qtite ,
        sum(ca_ht) as ca_ht ,
        sum(marge_brute) as marge_brute
from `bv-prod.Matillion_Perm_Table.TF_VENTE`
group by 1,2,3,4,5

      UNION ALL

select
        CODE_ACTEUR as CD_Magasin,
        DTE_VENTE,
        TYP_VENTE,
        ID_ARTICLE,
        ID_ARTICLE AS CD_Article_Original,
        sum(VAL_ACHAT_GBL) as Val_Achat_Gbl,
        sum(QTITE) as Qtite ,
        sum(CA_HT) as ca_ht,
        sum(MARGE_BRUTE) as marge_brute
from `bv-prod.Matillion_Perm_Table.DATA_QUALITY_VENTES_GOOGLE_SHEET`
group by 1,2,3,4,5) v


LEFT JOIN `bv-prod.Matillion_Perm_Table.Magasins` m ON   v.CD_Magasin = m.CD_Magasin
LEFT JOIN `bv-prod.Matillion_Perm_Table.ARTICLE_DWH` a ON  v.CD_Article = a.c_Article
LEFT JOIN `bv-prod.Matillion_Perm_Table.ARTICLE_ARBORESCENCE` arb ON arb.CodeArticle = v.CD_Article
LEFT JOIN `bv-prod.Matillion_Perm_Table.Marques` mq ON a.c_Marque = mq.cd_marque
LEFT JOIN `bv-prod.Matillion_Perm_Table.FOUR_DWH` f ON   a.c_Fournisseur = f.c_fournisseur

LEFT JOIN `bv-prod.Matillion_Perm_Table.Stock_DWH_Histo` s
ON  v.CD_Magasin = s.cd_acteur
AND  v.CD_Article  = CAST(s.cd_article AS STRING)
AND s.ScdDateDebut <= v.Dte_vte AND v.Dte_vte < s.ScdDateFin

FULL JOIN
(
    SELECT
      p.cd_produit as cd_produit,
      c.cd_magasin as cd_magasin,
      CAST(DATETIME_TRUNC(DATETIME(c.dte_commande), DAY) AS DATE) AS dte_cde,
      count(distinct(p.cd_commande)) as Nbre_commande ,
      sum(p.Quantite_commandee) as Quantite_commandee,
      sum(p.Tarif_Produit_HT) as Tarif_Produit_HT
      FROM `bv-prod.Matillion_Perm_Table.Produit_Commande` p
      INNER JOIN  `bv-prod.Matillion_Perm_Table.COMMANDES` c
      ON CAST(p.cd_commande AS STRING) = c.cd_commande
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

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
    view_label: "Magasins"
  }

  dimension: article {
    type: string
    sql: ${TABLE}.Article ;;
    view_label: "Article"
    label: "Code Article"
  }

  dimension: article_original {
    type: string
    sql: ${TABLE}.ArticleOriginal ;;
    view_label: "Article"
    label: "Code Article Original"
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
      article_original,
      typ_vente,
      qtite,
      ca_ht,
      marge_brute,
      marque,
      fournisseur,
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
    view_label: "Ventes"
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

  measure: marge_drive_select_mois {
    label: "marge drive"
    value_format_name: decimal_0
    type: number
    sql: ${sum_total_ht_select_mois}-${sum_val_achat_gbl_select_mois};;
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
    label: "Tarif Produit HT n-1"
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
    label: "Quantité commandée n-1"
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
    label: "Total HT n-1"
    type: number
    sql: ${sum_tarif_select_mois_N1} * ${sum_total_qte_com_select_mois_N1} ;;
    view_label: "Web"
    group_label: "Année N-1"
  }

  measure: marge_drive_select_mois_N1 {
    label: "Marge drive n-1"
    value_format_name: decimal_0
    type: number
    sql:  ${sum_total_ht_select_mois_N1}-${sum_val_achat_gbl_select_mois_N1};;
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
    label: "DN n-2"
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


# Calcul des Poids des divisions, familles, sous-familles


  measure: poids_division_sur_total {
    label: "Poids Division / Total"
    type: percent_of_total
    sql:  ${sum_CA_select_mois} ;;
    view_label: "Ventes"
    group_label: "Poids"
  }

}
