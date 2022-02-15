view: suivi_ga_2 {
  sql_table_name: `bv-prod.looker_pg.suivi_ga_2`
    ;;

  dimension: ca {
    type: number
    sql: ${TABLE}.CA ;;
  }

  dimension: conversion {
    type: number
    sql: ${TABLE}.conversion ;;
  }

  dimension: engaged_sessions {
    type: number
    sql: ${TABLE}.engaged_sessions ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: nb_acheteur {
    type: number
    sql: ${TABLE}.nb_acheteur ;;
  }

  dimension: nb_click {
    type: number
    sql: ${TABLE}.nb_click ;;
  }

  dimension: nb_fichier_telecharger {
    type: number
    sql: ${TABLE}.nb_fichier_telecharger ;;
  }

  dimension: nb_lecture_video {
    type: number
    sql: ${TABLE}.nb_lecture_video ;;
  }

  dimension: nb_recherche {
    type: number
    sql: ${TABLE}.nb_recherche ;;
  }

  dimension: nb_scoll {
    type: number
    sql: ${TABLE}.nb_scoll ;;
  }

  dimension: nouvelle_session {
    type: number
    sql: ${TABLE}.nouvelle_session ;;
  }

  dimension: session {
    type: number
    sql: ${TABLE}.session ;;
  }

  dimension: users {
    type: number
    sql: ${TABLE}.users ;;
  }

measure: taux_conversion{
  type: number
  sql: sum(${conversion}/ sum(${session} ;;
}

measure: taux_engagement {
  type: number
  sql: sum(${engaged_sessions} / sum(${session} ;;
}


  measure: count {
    type: count
    drill_fields: [name]
  }
}
