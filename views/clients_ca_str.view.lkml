view: clients_ca_str {
  sql_table_name: `ods.clients_ca_str`
    ;;

  dimension: ca_cumul_ht {
    type: string
    sql: ${TABLE}.CA_cumul_HT ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
  }

  dimension: date_dern_achat {
    type: string
    sql: ${TABLE}.date_dern_achat ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: mag_code {
    type: string
    sql: ${TABLE}.mag_code ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.nom ;;
  }

  dimension: periode {
    type: string
    sql: ${TABLE}.periode ;;
  }

  dimension: prenom {
    type: string
    sql: ${TABLE}.prenom ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: tec_date_alim {
    type: string
    sql: ${TABLE}.TEC_date_alim ;;
  }

  dimension: tec_date_maj {
    type: string
    sql: ${TABLE}.TEC_date_maj ;;
  }

  dimension: tec_fic_src {
    type: string
    sql: ${TABLE}.TEC_Fic_src ;;
  }

  dimension: tec_num_ligne {
    type: string
    sql: ${TABLE}.TEC_Num_Ligne ;;
  }

  dimension: tel_port {
    type: string
    sql: ${TABLE}.tel_port ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
