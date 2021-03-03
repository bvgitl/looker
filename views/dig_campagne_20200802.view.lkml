view: dig_campagne_20200802 {
  sql_table_name: `ods.dig_campagne_20200802`
    ;;

  dimension: clics {
    type: number
    sql: ${TABLE}.Clics ;;
  }

  dimension: customer_group_code {
    type: string
    sql: ${TABLE}.customer_group_code ;;
  }

  dimension: dernier_npai {
    type: string
    sql: ${TABLE}.Dernier_NPAI ;;
  }

  dimension: derniere_desinscription {
    type: string
    sql: ${TABLE}.Derniere_desinscription ;;
  }

  dimension: derniere_plainte {
    type: string
    sql: ${TABLE}.Derniere_plainte ;;
  }

  dimension: dernieres_ouvertures {
    type: string
    sql: ${TABLE}.Dernieres_ouvertures ;;
  }

  dimension: dernieres_reponses {
    type: string
    sql: ${TABLE}.Dernieres_reponses ;;
  }

  dimension: desinscrit {
    type: number
    sql: ${TABLE}.Desinscrit ;;
  }

  dimension: desktop {
    type: yesno
    sql: ${TABLE}.Desktop ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.Email ;;
  }

  dimension: lien_url {
    type: string
    sql: ${TABLE}.Lien_url ;;
  }

  dimension: mobile {
    type: yesno
    sql: ${TABLE}.Mobile ;;
  }

  dimension: n_de_mobile {
    type: string
    sql: ${TABLE}.N_de_mobile ;;
  }

  dimension: nom_du_magasin {
    type: string
    sql: ${TABLE}.Nom_du_magasin ;;
  }

  dimension: npai {
    type: number
    sql: ${TABLE}.NPAI ;;
  }

  dimension: ouvertures {
    type: number
    sql: ${TABLE}.Ouvertures ;;
  }

  dimension: plainte {
    type: number
    sql: ${TABLE}.Plainte ;;
  }

  dimension: reponses {
    type: number
    sql: ${TABLE}.Reponses ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
