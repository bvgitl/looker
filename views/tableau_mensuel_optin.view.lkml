
view: tableau_mensuel_optin {
  derived_table: {
    sql: SELECT * FROM bv-prod.CRM_Stats.Suivi_Optin ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: storecode {
    type: string
    sql: ${TABLE}.storecode ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.nom ;;
  }

  dimension: format {
    type: string
    sql: ${TABLE}.Format ;;
  }

  dimension: tranche_age {
    type: string
    sql: ${TABLE}.Tranche_age ;;
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
  }

  dimension: animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
  }

  dimension: nb_clients_mag {
    type: number
    sql: ${TABLE}.nb_clients_mag ;;
  }

  dimension: nb_email_mag {
    type: number
    sql: ${TABLE}.nb_email_mag ;;
  }

  dimension: nb_email_mag_optin {
    type: number
    sql: ${TABLE}.nb_email_mag_optin ;;
  }

  dimension: nb_email_mag_optin_prof {
    type: number
    sql: ${TABLE}.nb_email_mag_optin_prof ;;
  }

  dimension: nb_email_mag_optin_vide_prof {
    type: number
    sql: ${TABLE}.nb_email_mag_optin_vide_prof ;;
  }

  dimension: nb_email_mag_optin_part {
    type: number
    sql: ${TABLE}.nb_email_mag_optin_part ;;
  }

  dimension: nb_sms_mag {
    type: number
    sql: ${TABLE}.nb_sms_mag ;;
  }

  dimension: nb_sms_mag_optin {
    type: number
    sql: ${TABLE}.nb_sms_mag_optin ;;
  }

  dimension: nb_sms_mag_optin_prof {
    type: number
    sql: ${TABLE}.nb_sms_mag_optin_prof ;;
  }

  dimension: nb_sms_mag_optin_vide_prof {
    type: number
    sql: ${TABLE}.nb_sms_mag_optin_vide_prof ;;
  }

  dimension: nb_sms_mag_optin_part {
    type: number
    sql: ${TABLE}.nb_sms_mag_optin_part ;;
  }

  dimension: nb_email_retail {
    type: number
    sql: ${TABLE}.nb_email_retail ;;
  }

  dimension: pc_email_optin_raw {
    type: number
    sql: ${TABLE}.pc_email_optin_raw ;;
  }

  dimension: pc_email_optin_net {
    type: number
    sql: ${TABLE}.pc_email_optin_net ;;
  }

  dimension: pc_sms_optin_raw {
    type: number
    sql: ${TABLE}.pc_sms_optin_raw ;;
  }

  dimension: pc_sms_optin_net {
    type: number
    sql: ${TABLE}.pc_sms_optin_net ;;
  }

  set: detail {
    fields: [
        storecode,
	nom,
	format,
	tranche_age,
	typ_mag,
	animateur,
	region,
	nb_clients_mag,
	nb_email_mag,
	nb_email_mag_optin,
	nb_email_mag_optin_prof,
	nb_email_mag_optin_vide_prof,
	nb_email_mag_optin_part,
	nb_sms_mag,
	nb_sms_mag_optin,
	nb_sms_mag_optin_prof,
	nb_sms_mag_optin_vide_prof,
	nb_sms_mag_optin_part,
	nb_email_retail,
	pc_email_optin_raw,
	pc_email_optin_net,
	pc_sms_optin_raw,
	pc_sms_optin_net
    ]
  }
}
