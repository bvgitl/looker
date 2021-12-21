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

  dimension_group: DateMonitoring {
    type: time
    timeframes: [
      raw,
      week,
      date,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.DateMonitoring ;;
  }

  dimension: Flux {
    type: string
    sql: ${TABLE}.Flux ;;
  }

  dimension: GroupeFlux {
    type: string
    sql: ${TABLE}.GroupeFlux ;;
  }

  dimension: CodeMagasinExterne   {
    type: string
    sql: ${TABLE}.CodeMagasinExterne  ;;
  }

  dimension: CodeMagasinActeur   {
    type: string
    sql: ${TABLE}.CodeMagasinActeur  ;;
  }

  dimension: CodeTerritoire   {
    type: string
    sql: ${TABLE}.CodeTerritoire  ;;
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

  dimension: NomFichierPretty {
    type: string
    sql: REPLACE(REPLACE(
        REPLACE(REPLACE(REPLACE(REPLACE(
        ${TABLE}.NomFichier, '[0-2][0-9][0-9][0-9]', 'yyyy'), '[0-1][0-9]', 'MM'), '[0-3][0-9]', 'dd'), '[0-9][0-9][0-9][0-9][0-9][0-9]', 'hhmmss')
        , '[cC][sS][vV]', 'csv'), '[.][tT][xX][tT]', 'txt')
        ;;
  }

  dimension: Flux_Global {
    type: yesno
    sql: ${TABLE}.Flux NOT IN ('BCP10_BCP13', 'Clients Retail', 'Web Inter') ;;
  }

  dimension: Flux_ClientRetail {
    type: yesno
    sql: ${TABLE}.Flux = 'Clients Retail' ;;
  }

  dimension: Flux_BCP10_BCP13 {
    type: yesno
    sql: ${TABLE}.Flux = 'BCP10_BCP13' ;;
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
