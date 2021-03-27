view: tf_vente {
  sql_table_name: `bv-prod.Matillion_Perm_Table.TF_VENTE`
    ;;

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${cd_site_ext}, ' ',${dte_vte_date}, ' ',${typ_vente}, ' ',${cd_article}) ;;
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

  dimension: cd_site_ext {
    type: string
    sql: ${TABLE}.CD_Site_Ext ;;
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
    sql: ${marge_brute}/${ca_ht} ;;
  }


  ########################### KPIs Data Quality #######################

  filter: date_filter {                 ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n"
    type: date
  }

  measure: sum_ca_ht_article {
    label: "ca_ht articles"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
  }

  measure: sum_marge_brute_article {
    label: "marge_brute articles"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
  }

    measure: sum_ca_ht_mag {
      label: "ca_ht mag"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter %} CAST(${tf_vente_mag.dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${tf_vente_mag.ca_ht}
          END ;;
    }

    measure: sum_marge_brute_mag {
      label: "marge_brute mag"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter %} CAST(${tf_vente_mag.dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${tf_vente_mag.marge_brute}
          END ;;
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
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${compound_primary_key}
          END ;;
    filters: [ca_ht: "0"]
    drill_fields: [sheet*]
  }

  measure: Nb_Lignes_tx_Marge {
    label: "Nbre de lignes tx Marge >1"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${compound_primary_key}
          END ;;
    filters: [tx_marge_brute: ">1"]
    drill_fields: [sheet*]
  }

  measure: Nb_Lignes_Marge_Negatif {
    label: "Nbre de lignes Marge <01"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${compound_primary_key}
          END ;;
    filters: [marge_brute: "<0"]
    drill_fields: [sheet*]
  }

  set: sheet_diff {
    fields: [cd_site_ext, dte_vte_date, cd_article, typ_vente, Ecarts_CA, Ecarts_Marge_Brute]
  }

  set: sheet {
    fields: [cd_site_ext, dte_vte_date, cd_article, typ_vente, ca_ht, marge_brute]
  }
}
