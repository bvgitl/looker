view: test {
  sql_table_name: `bv-prod.looker_pg.test`
    ;;

  dimension: anciennete_jour {
    type: number
    sql: ${TABLE}.anciennete_jour ;;
  }

  dimension: anciennete_mois {
    type: number
    sql: ${TABLE}.anciennete_mois ;;
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.ca_ht ;;
  }

  dimension: ca_ht_12_18_month {
    type: number
    sql: ${TABLE}.ca_ht_12_18_month ;;
  }

  dimension: ca_ht_18_24_month {
    type: number
    sql: ${TABLE}.ca_ht_18_24_month ;;
  }

  dimension: ca_ht_3_month {
    type: number
    sql: ${TABLE}.ca_ht_3_month ;;
  }

  dimension: ca_ht_6_12_month {
    type: number
    sql: ${TABLE}.ca_ht_6_12_month ;;
  }

  dimension: ca_ht_6_month {
    type: number
    sql: ${TABLE}.ca_ht_6_month ;;
  }

  dimension: ca_ht_delai_inter {
    type: number
    sql: ${TABLE}.ca_ht_delai_inter ;;
  }

  dimension: ca_ttc {
    type: number
    sql: ${TABLE}.ca_ttc ;;
  }

  dimension: categorie_pro {
    type: string
    sql: ${TABLE}.categorie_pro ;;
  }

  dimension: cd_magasin_de_rattachement {
    type: string
    sql: ${TABLE}.cd_magasin_de_rattachement ;;
  }

  dimension: civilite {
    type: string
    sql: ${TABLE}.civilite ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension_group: date_creation {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date_creation ;;
  }

  dimension_group: date_last_achat {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date_last_achat ;;
  }

  dimension: flag_ca_ht_12_18_month {
    type: number
    sql: ${TABLE}.flag_ca_ht_12_18_month ;;
  }

  dimension: flag_ca_ht_18_24_month {
    type: number
    sql: ${TABLE}.flag_ca_ht_18_24_month ;;
  }

  dimension: flag_ca_ht_3_month {
    type: number
    sql: ${TABLE}.flag_ca_ht_3_month ;;
  }

  dimension: flag_ca_ht_6_12_month {
    type: number
    sql: ${TABLE}.flag_ca_ht_6_12_month ;;
  }

  dimension: flag_ca_ht_6_month {
    type: number
    sql: ${TABLE}.flag_ca_ht_6_month ;;
  }

  dimension: flag_mono_acheteur_12_month {
    type: number
    sql: ${TABLE}.flag_mono_acheteur_12_month ;;
  }

  dimension: flag_mono_acheteur_18_month {
    type: number
    sql: ${TABLE}.flag_mono_acheteur_18_month ;;
  }

  dimension: flag_mono_acheteur_24_month {
    type: number
    sql: ${TABLE}.flag_mono_acheteur_24_month ;;
  }

  dimension: flag_mono_acheteur_3_month {
    type: number
    sql: ${TABLE}.flag_mono_acheteur_3_month ;;
  }

  dimension: flag_mono_acheteur_6_month {
    type: number
    sql: ${TABLE}.flag_mono_acheteur_6_month ;;
  }

  dimension: nb_commande_ko {
    type: number
    sql: ${TABLE}.nb_commande_ko ;;
  }

  dimension: nb_commande_ok {
    type: number
    sql: ${TABLE}.nb_commande_ok ;;
  }

  dimension: nb_commande_ok_12_month {
    type: number
    sql: ${TABLE}.nb_commande_ok_12_month ;;
  }

  dimension: nb_commande_ok_18_month {
    type: number
    sql: ${TABLE}.nb_commande_ok_18_month ;;
  }

  dimension: nb_commande_ok_24_month {
    type: number
    sql: ${TABLE}.nb_commande_ok_24_month ;;
  }

  dimension: nb_commande_ok_30_month {
    type: number
    sql: ${TABLE}.nb_commande_ok_30_month ;;
  }

  dimension: nb_commande_ok_3_month {
    type: number
    sql: ${TABLE}.nb_commande_ok_3_month ;;
  }

  dimension: nb_commande_ok_6_month {
    type: number
    sql: ${TABLE}.nb_commande_ok_6_month ;;
  }

  dimension: optin_email {
    type: string
    sql: ${TABLE}.optin_email ;;
  }

  dimension: optin_sms {
    type: string
    sql: ${TABLE}.optin_sms ;;
  }

  dimension: pm {
    type: number
    sql: ${TABLE}.pm ;;
  }

  dimension: qte {
    type: number
    sql: ${TABLE}.QTE ;;
  }

  dimension: recence {
    type: number
    sql: ${TABLE}.recence ;;
  }

  dimension: total_commande {
    type: number
    sql: ${TABLE}.total_commande ;;
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
