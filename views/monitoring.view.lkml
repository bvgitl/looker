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

}
