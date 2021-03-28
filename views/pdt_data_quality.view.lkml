view: pdt_data_quality {
  derived_table: {
    sql: select
        CD_Site_Ext ,
        Dte_Vte ,
        Typ_Vente ,
        Val_Achat_Gbl ,
        Qtite ,
        ca_ht ,
        marge_brute ,
        nb_ticket,
        'Articles' AS Origine,
        row_number() OVER(ORDER BY Dte_Vte) AS primary_key
  from `bv-prod.Matillion_Perm_Table.TF_VENTE`

  UNION ALL

  select
        CD_Site_Ext ,
        Dte_Vte ,
        Typ_Vente ,
        Val_Achat_Gbl ,
        Qtite ,
        ca_ht ,
        marge_brute ,
        nb_ticket ,
        'Magasins' AS Origine ,
        row_number() OVER(ORDER BY Dte_Vte) AS primary_key
    from `bv-prod.Matillion_Perm_Table.TF_VENTE_MAG`

        LIMIT 10
 ;;
  }

  dimension: primary_key {
    type: number
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.primary_key ;;
  }

  dimension: cd_site_ext {
    type: string
    sql: ${TABLE}.CD_Site_Ext ;;
  }

  dimension_group: dte_vte {
    type: time
    timeframes: [date, raw]
    datatype: date
    sql: ${TABLE}.Dte_Vte ;;
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.Typ_Vente ;;
  }

  dimension: val_achat_gbl {
    type: number
    sql: ${TABLE}.Val_Achat_Gbl ;;
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

  dimension: origine {
    type: string
    sql: ${TABLE}.Origine ;;
  }

  dimension: tx_marge_brute {
    type: number
    sql: ${marge_brute}/NULLIF(${ca_ht},0) ;;
  }


  measure: sum_ca_ht_article {
    label: "ca_ht articles"
    type: sum
    value_format_name: eur
    sql: ${ca_ht} ;;
    filters: [origine: "Aricles"]
  }

  measure: sum_marge_brute_article {
    label: "marge_brute articles"
    type: sum
    value_format_name: eur
    sql: ${marge_brute} ;;
    filters: [origine: "Articles"]
  }

  measure: sum_ca_ht_mag {
    label: "ca_ht mag"
    type: sum
    value_format_name: eur
    sql: ${ca_ht} ;;
    filters: [origine: "Magasins"]
  }


  measure: sum_marge_brute_mag {
    label: "marge_brute mag"
    type: sum
    value_format_name: eur
    sql: ${marge_brute} ;;
    filters: [origine: "Magasins"]
  }

  measure: Ecarts_CA {
    type: number
    value_format_name: eur
    sql: ${sum_ca_ht_mag}-${sum_ca_ht_article} ;;
    drill_fields: [sheet_diff*]
  }

  measure: Ecarts_Marge_Brute {
    type: number
    value_format_name: eur
    sql: ${sum_marge_brute_mag}-${sum_marge_brute_article} ;;
    drill_fields: [sheet_diff*]
  }

  measure: Nb_Lignes_CA_Null {
    label: "Nbre de lignes CA = 0"
    type: count_distinct
    sql: ${primary_key} ;;
    value_format_name: decimal_0
    filters: [origine: "Articles", ca_ht: "0"]
    drill_fields: [sheet*]
  }

  measure: Nb_Lignes_tx_Marge {
    label: "Nbre de lignes tx Marge >1"
    type: count_distinct
    value_format_name: decimal_0
    sql: ${primary_key} ;;
    filters: [origine: "Articles", tx_marge_brute: ">1"]
    drill_fields: [sheet*]
  }

  measure: Nb_Lignes_Marge_Negatif {
    label: "Nbre de lignes Marge <0"
    type: count_distinct
    value_format_name: decimal_0
    sql: ${primary_key} ;;
    filters: [origine: "Articles" , marge_brute: "<0"]
    drill_fields: [sheet*]
  }

  set: sheet_diff {
    fields: [cd_site_ext, dte_vte_date, typ_vente, Ecarts_CA, Ecarts_Marge_Brute]
  }

  set: sheet {
    fields: [cd_site_ext, dte_vte_date, typ_vente, ca_ht, marge_brute]
  }
}
