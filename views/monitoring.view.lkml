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

  dimension: EstObligatoire {
    type: yesno
    sql: ${TABLE}.Obligatoire ;;
  }

  dimension: Erreur {
    type: string
    sql: ${TABLE}.Erreur ;;
  }

  dimension: TypeErreur {
    type:  string
    sql:  CASE
      WHEN ${TABLE}.Erreur LIKE '%non reçu%' AND ${TABLE}.Obligatoire = true THEN 'Manquant et atttendu'
      WHEN ${TABLE}.Erreur LIKE '%non reçu%' AND ${TABLE}.Obligatoire = false THEN 'Manquant mais non-attendu'
      ELSE 'Erreur'
      END;;
  }

  dimension: NomFichier {
    type: string
    sql: ${TABLE}.NomFichier ;;
  }

  dimension: NomFichierPretty {
    type: string
    sql: REPLACE(REPLACE(REPLACE(
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        ${TABLE}.NomFichier
        , '[0-2][0-9][0-9][0-9]', CAST(EXTRACT(YEAR FROM DateFichier) AS STRING)), '[0-1][0-9]', RIGHT('0' || CAST(EXTRACT(MONTH FROM DateFichier) AS STRING), 2)), '[0-3][0-9]', RIGHT('0' || CAST(EXTRACT(DAY FROM DateFichier) AS STRING), 2)), '[0-9][0-9][0-9][0-9][0-9][0-9]', '<hhmmss>')
        , '[cC][sS][vV]', 'csv'), '[tT][xX][tT]', 'TXT'), '...', CodeMagasinExterne), '_.._..', '_' || CodeTerritoire), '[.]', '.')
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

  measure: count_ko_missing_expected {
    type: count
    filters: [EstOK: "no", TypeErreur: "Manquant et atttendu"]
    drill_fields: []
  }

  measure: count_ko_missing_unexpected {
    type: count
    filters: [EstOK: "no", TypeErreur: "Manquant mais non-attendu"]
    drill_fields: []
  }

  measure: count_ko_error {
    type: count
    filters: [EstOK: "no", TypeErreur: "Erreur"]
    drill_fields: []
  }

}
