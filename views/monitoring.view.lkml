view: monitoring {
  sql_table_name: Matillion_Monitoring.MonitoringFichier ;;

  dimension_group: DateFichier {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.DateFichier ;;
  }

  dimension: Flux {
    type: string
    sql: ${TABLE}.Flux ;;
  }

  dimension: GroupeFlux {
    type: string
    sql: ${TABLE}.GroupeFlux ;;
  }

  dimension: CodeMagasin   {
    type: string
    sql: ${TABLE}.CodeMagasin  ;;
  }

  dimension: EstOK {
    type: yesno
    sql: ${TABLE}.EstOK ;;
  }

  dimension: Erreur {
    type: string
    sql: ${TABLE}.Erreur ;;
  }

  dimension: NomFichier {
    type: string
    sql: ${TABLE}.NomFichier ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: count_ok {
    type: count
    filters: [EstOK: "yes"]
    drill_fields: []
  }

  measure: count_ko {
    type: count
    filters: [EstOK: "no"]
    drill_fields: []
  }

}
