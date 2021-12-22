view: tract {
  sql_table_name: Matillion_Perm_Table.TRACTS_GOOGLE_SHEET ;;

  dimension_group: DateDebutTract {
    label: "Date de début"
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
    sql: ${TABLE}.DATE_DEBUT_TRACT ;;
  }

  dimension_group: DateFinTract {
    label: "Date de fin"
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
    sql: ${TABLE}.DATE_FIN_TRACT ;;
  }

  dimension: CodeActeur {
    label: "Code Acteur"
    type: string
    sql: ${TABLE}.CODE_ACTEUR ;;
  }

  dimension: NomMagasin {
    label: "Nom Magasin"
    type: string
    sql: ${TABLE}.NOM_MAGASIN ;;
  }

  dimension: MiseEnAvantWeb {
    label: "Mise en avant Web"
    type: string
    sql: ${TABLE}.MiseEnAvantWeb ;;
  }

  dimension: BoosterBonial {
    label: "Booster Bonial"
    type: string
    sql: ${TABLE}.BoosterBonial ;;
  }

  dimension: Email {
    label: "E-mail"
    type: string
    sql: ${TABLE}.Email ;;
  }

  dimension: PostsFacebookGeolocalises {
    label: "Posts Facebook Géolocalisés"
    type: string
    sql: ${TABLE}.PostsFacebookGeolocalises ;;
  }

  dimension: SMS {
    label: "SMS"
    type: string
    sql: ${TABLE}.SMS ;;
  }

  dimension: SpotRadioShop {
    label: "Spot Radio Shop"
    type: string
    sql: ${TABLE}.SpotRadioShop ;;
  }

  dimension: PLVMoyenKit {
    label: "PLV Moyen Kit"
    type: string
    sql: ${TABLE}.PLVMoyenKit ;;
  }

  dimension: PLVGrandKit {
    label: "PLV Grand Kit"
    type: string
    sql: ${TABLE}.PLVGrandKit ;;
  }

  dimension: NomOperation {
    label: "Nom Operation"
    type: string
    sql: ${TABLE}.NOM_OPERATION ;;
  }

  dimension: Specificite {
    label: "Spécificité"
    type: string
    sql: ${TABLE}.SPECIFICITE  ;;
  }

  dimension: EstEngage {
    label: "Est Engagé ?"
    type: yesno
    sql: CASE WHEN ${TABLE}.QTE_TRACT > 0 THEN true ELSE false END  ;;
  }

  dimension: Quantite {
    label: "Quantité"
    type: number
    sql: ${TABLE}.QTE_TRACT ;;
  }

  measure: QuantiteTract {
    label: "Quantité Tract"
    type: sum
    sql: ${Quantite} ;;
    filters: []
    drill_fields: []
  }

  measure: NbMagasinEngage {
    label: "Nb Magasin Engagé"
    type: count_distinct
    sql: ${TABLE}.CODE_ACTEUR ;;
    filters: [ EstEngage: "yes" ]
    drill_fields: []
  }

}
