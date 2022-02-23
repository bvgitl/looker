view: monitoring {
  sql_table_name: Matillion_Monitoring.MonitoringFichier ;;

  dimension_group: DateFichier {
    label: "Date Fichier"
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
    label: "Date Monitoring"
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
    label: "Flux"
    type: string
    sql: ${TABLE}.Flux ;;
  }

  dimension: GroupeFlux {
    label: "Groupe Flux"
    type: string
    sql: ${TABLE}.GroupeFlux ;;
  }

  dimension: CodeMagasinExterne   {
    label: "Code Magasin (externe)"
    type: string
    sql: ${TABLE}.CodeMagasinExterne  ;;
  }

  dimension: CodeMagasinActeur   {
    label: "Code Magasin (acteur)"
    type: string
    sql: ${TABLE}.CodeMagasinActeur  ;;
  }

  dimension: CodeTerritoire   {
    label: "Code Territoire"
    type: string
    sql: ${TABLE}.CodeTerritoire  ;;
  }

  dimension: EstOK {
    label: "Est OK ?"
    type: yesno
    sql: ${TABLE}.EstOK ;;
  }

  dimension: EstObligatoire {
    label: "Est Obligatoire ?"
    type: yesno
    sql: ${TABLE}.Obligatoire ;;
  }

  dimension: Erreur {
    label: "Erreur"
    type: string
    sql: ${TABLE}.Erreur ;;
  }

  dimension: TypeErreur {
    label: "Type Erreur"
    type:  string
    sql:  CASE
      WHEN ${TABLE}.EstOK = true THEN "OK"
      WHEN ${TABLE}.Erreur LIKE '%non reçu%' AND ${TABLE}.Obligatoire = true THEN 'KO - Manquant et atttendu'
      WHEN ${TABLE}.Erreur LIKE '%non reçu%' AND ${TABLE}.Obligatoire = false THEN 'Manquant mais non-attendu'
      ELSE 'KO - Erreur'
      END;;
  }

  dimension: NomFichier {
    label: "Nom Fichier (brut)"
    type: string
    sql: ${TABLE}.NomFichier ;;
  }

  dimension: NomFichierPretty {
    label: "Nom Fichier"
    type: string
    sql: REPLACE(REPLACE(REPLACE(
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        ${TABLE}.NomFichier
        , '[0-2][0-9][0-9][0-9]', CAST(EXTRACT(YEAR FROM DateFichier) AS STRING)), '[0-1][0-9]', RIGHT('0' || CAST(EXTRACT(MONTH FROM DateFichier) AS STRING), 2)), '[0-3][0-9]', RIGHT('0' || CAST(EXTRACT(DAY FROM DateFichier) AS STRING), 2)), '[0-9][0-9][0-9][0-9][0-9][0-9]', '<hhmmss>')
        , '[cC][sS][vV]', 'csv'), '[tT][xX][tT]', 'TXT'), '...', CodeMagasinExterne), '_.._..', '_' || CodeTerritoire), '[.]', '.')
        ;;
  }

  dimension: Flux_Global {
    label: "Flux Global ?"
    type: yesno
    sql: ${TABLE}.GroupeFlux IN ('COR', 'Web') ;;
  }

  dimension: Flux_WebInter {
    label: "Flux Web Inter ?"
    type: yesno
    sql: ${TABLE}.GroupeFlux = 'Web Inter' ;;
  }

  dimension: Flux_ClientRetail {
    label: "Flux Client Reatil ?"
    type: yesno
    sql: ${TABLE}.GroupeFlux = 'Retail' ;;
  }

  dimension: Flux_BCP10_BCP13 {
    label: "Flux Vente ?"
    type: yesno
    sql: ${TABLE}.GroupeFlux = 'Vente' ;;
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
    filters: [EstOK: "no", TypeErreur: "KO - Manquant et atttendu"]
    drill_fields: []
  }

  measure: count_ko_missing_unexpected {
    type: count
    filters: [EstOK: "no", TypeErreur: "Manquant mais non-attendu"]
    drill_fields: []
  }

  measure: count_ko_error {
    type: count
    filters: [EstOK: "no", TypeErreur: "KO - Erreur"]
    drill_fields: []
  }

}
