view: tf_vente_mag {
  sql_table_name: `bv-prod.Matillion_Perm_Table.TF_VENTE_MAG`
    ;;

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${cd_site_ext}, ' ',${dte_vte_date}, ' ',${typ_vente}) ;;
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

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
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

  dimension: qtite {
    type: number
    sql: ${TABLE}.Qtite ;;
  }

  dimension: qtite_uvc {
    type: number
    sql: ${TABLE}.Qtite_uvc ;;
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

########################### KPIs #######################

  # measure: sum_ca_ht_mag {
  #   label: "ca_ht mag"
  #   type: sum
  #   value_format_name: eur
  #   sql: ${ca_ht} ;;
  # }

  # dimension: tot_tx_marge_brute_mag {
  #   label: "% marge mag"
  #   type: number
  #   value_format_name: percent_2
  #   sql:  1.0 * ${marge_brute}/NULLIF(${ca_ht},0) ;;
  # }

  # measure: sum_marge_brute_mag {
  #   label: "marge_brute mag"
  #   value_format_name: eur
  #   type: sum
  #   sql: ${marge_brute} ;;
  # }

  # measure: sum_nb_ticket_mag {
  #   value_format_name: decimal_0
  #   hidden: yes
  #   type: sum
  #   sql: ${nb_ticket} ;;
  # }

  # measure: sum_qtite_mag {
  #   value_format_name: decimal_0
  #   hidden: yes
  #   type: sum
  #   sql: ${qtite};;
  # }

  # measure: sum_val_achat_gbl_mag {
  #   value_format_name: eur
  #   hidden: yes
  #   type: sum
  #   sql: ${val_achat_gbl} ;;
  # }


}
