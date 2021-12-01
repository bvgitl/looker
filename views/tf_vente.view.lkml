view: tf_vente {
  sql_table_name: `bv-prod.Matillion_Perm_Table.TF_VENTE`
    ;;

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${cd_magasin}, ' ',${dte_vte_date}, ' ',${typ_vente}, ' ',${cd_article}) ;;
  }


  dimension: an_sem {
    type: string
    sql: ${TABLE}.An_Sem ;;
  }

  dimension: annee {
    type: string
    sql: ${TABLE}.Annee ;;
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.ca_ht ;;
  }

  dimension: ca_net {
    type: number
    sql: ${TABLE}.ca_net ;;
  }

  dimension: cd_article {
    type: string
    sql: ${TABLE}.CD_Article ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
  }

  dimension: cd_niv_1 {
    type: string
    sql: ${TABLE}.CD_Niv_1 ;;
  }

  dimension: cd_niv_2 {
    type: string
    sql: ${TABLE}.CD_Niv_2 ;;
  }

  dimension: cd_niv_3 {
    type: string
    sql: ${TABLE}.CD_Niv_3 ;;
  }

  dimension: cd_pays {
    type: string
    sql: ${TABLE}.CD_Pays ;;
  }

  dimension_group: dte_creat {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Dte_creat ;;
  }

  dimension_group: dte_vte {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Dte_Vte ;;
  }

  dimension: jour {
    type: string
    sql: ${TABLE}.Jour ;;
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.marge_brute ;;
  }

  dimension: mois {
    type: string
    sql: ${TABLE}.Mois ;;
  }

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.nb_ticket ;;
  }

  dimension: num_jour {
    type: string
    sql: ${TABLE}.Num_Jour ;;
  }

  dimension: num_niv_1 {
    type: string
    sql: ${TABLE}.Num_Niv_1 ;;
  }

  dimension: num_niv_2 {
    type: string
    sql: ${TABLE}.Num_Niv_2 ;;
  }

  dimension: num_niv_3 {
    type: string
    sql: ${TABLE}.Num_Niv_3 ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.Qtite ;;
  }

  dimension: qtite_uvc {
    type: number
    sql: ${TABLE}.Qtite_uvc ;;
  }

  dimension: statut_article {
    type: string
    sql: ${TABLE}.Statut_Article ;;
  }

  dimension: typ_article {
    type: string
    sql: ${TABLE}.Typ_Article ;;
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.Typ_Vente ;;
  }

  dimension: val_achat_gbl {
    type: number
    sql: ${TABLE}.Val_Achat_Gbl ;;
  }

  dimension: tx_marge_brute {
    type: number
    sql: ${marge_brute}/NULLIF(${ca_ht},0) ;;
  }

  measure: Nb_Lignes_CA_Null {
    label: "Nbre de lignes CA = 0"
    type: count_distinct
    value_format_name: decimal_0
    sql:  ${compound_primary_key} ;;
    filters: [ca_ht: "0"]
    drill_fields: [sheet_ca*]
  }

  measure: Nb_Lignes_tx_Marge {
    label: "Nbre de lignes tx Marge >1"
    type: count_distinct
    value_format_name: decimal_0
    sql: ${compound_primary_key} ;;
    filters: [tx_marge_brute: ">1"]
    drill_fields: [sheet_marge*]
  }

  measure: Nb_Lignes_Marge_Negatif {
    label: "Nbre de lignes Marge <0"
    type: count_distinct
    value_format_name: decimal_0
    sql:  ${compound_primary_key} ;;
    filters: [marge_brute: "<0"]
    drill_fields: [sheet_marge*]
  }

  set: sheet_diff {
    fields: [magasins.cd_magasin, dte_vte_date, cd_article, typ_vente]
  }

  set: sheet_ca {
    fields: [magasins.cd_magasin, dte_vte_date, cd_article, typ_vente, ca_ht]
  }

  set: sheet_marge {
    fields: [magasins.cd_magasin, dte_vte_date, cd_article, typ_vente, marge_brute]
  }
}
