view: suivi_ga_2 {
  sql_table_name: `bv-prod.looker_pg.suivi_ga_2`
    ;;

  dimension: achat {
    type: number
    sql: ${TABLE}.achat ;;
  }

  dimension: click {
    type: number
    sql: ${TABLE}.click ;;
  }

  dimension: engagement_time_msec {
    type: number
    sql: ${TABLE}.engagement_time_msec ;;
  }

  dimension: file_download {
    type: number
    sql: ${TABLE}.file_download ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: nouvelle_session {
    type: number
    sql: ${TABLE}.nouvelle_session ;;
  }

  dimension: purchase_revenue {
    type: number
    sql: ${TABLE}.purchase_revenue ;;
  }

  dimension: scroll {
    type: number
    sql: ${TABLE}.scroll ;;
  }

  dimension: session_engaged {
    type: string
    sql: ${TABLE}.session_engaged ;;
  }

  dimension: session_id {
    type: number
    sql: ${TABLE}.session_id ;;
  }

  dimension: transaction_id {
    type: string
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: user_pseudo_id {
    type: string
    sql: ${TABLE}.user_pseudo_id ;;
  }

  dimension: video_progress {
    type: number
    sql: ${TABLE}.video_progress ;;
  }

  dimension: view_search_results {
    type: number
    sql: ${TABLE}.view_search_results ;;
  }

  measure:  users {
    type: count_distinct
    sql: ${user_pseudo_id} ;;
  }

  measure:  session {
    type: count_distinct
    sql: ${session_id} ;;
    }

  measure: nb_acheteur {
    type: sum
    sql:  ${achat} ;;
  }

  measure:  nb_nouvelle_session {
    type: sum
    sql: ${nouvelle_session} ;;
  }

  measure: engaged_session {
    type: count_distinct
    sql: case when ${session_engaged} = 1 then ${session_id} ;;
  }

  measure: conversion {
    type: count_distinct
    sql: ${transaction_id} ;;
  }

  measure:  CA {
    type:  sum
    sql: ${purchase_revenue} ;;
  }

  measure:  taux_conversion {
    type: number
    sql: ${conversion} / ${session} ;;
  }

  measure:  taux_engement {
    type: number
    sql: ${engaged_session} /${session} ;;
  }


  measure: count {
    type: count
    drill_fields: [name]
  }
}
