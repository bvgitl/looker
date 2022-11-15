view: ref_campagne {
  sql_table_name: `bv-prod.looker_pg.ref_campagne`
    ;;

  dimension: bounce_type {
    type: string
    sql: ${TABLE}.bounce_type ;;
    drill_fields: [sheet_client*]
  }

  dimension: camp_id {
    type: string
    sql: ${TABLE}.camp_id ;;
    drill_fields: [sheet_client*]
  }

  dimension: camp_name {
    type: string
    sql: case when ${TABLE}.camp_name not like "%test%"
          then split(${TABLE}.camp_name , '_CELL')[offset(0)] end ;;

    drill_fields: [sheet_client*]
    suggest_persist_for: "2 seconds"
  }

  dimension: category_id {
    type: string
    sql: ${TABLE}.category_id ;;
    drill_fields: [sheet_client*]
  }

  dimension: category_name {
    type: string
    sql: ${TABLE}.category_name ;;
    drill_fields: [sheet_client*]
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
    drill_fields: [sheet_client*]
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
    drill_fields: [sheet_client*]
  }

  dimension_group: date_creation {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql:cast( ${TABLE}.date_creation  as TIMESTAMP);;
    drill_fields: [sheet_client*]
  }

  dimension_group: dt_bounce {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: cast( ${TABLE}.dt_bounce_time  as TIMESTAMP);;
    drill_fields: [sheet_client*]
  }

  dimension_group: dt_click {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: cast(${TABLE}.dt_click_time  as TIMESTAMP) ;;
    drill_fields: [sheet_client*]
  }

  dimension_group: dt_send {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: cast(${TABLE}.dt_send_time  as TIMESTAMP);;
    drill_fields: [sheet_client*]
  }

  dimension_group: dt_unsub {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql:cast( ${TABLE}.dt_unsub_time  as TIMESTAMP) ;;
    drill_fields: [sheet_client*]
  }

  dimension_group: dte_open {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: cast( ${TABLE}.dte_open  as TIMESTAMP) ;;
    drill_fields: [sheet_client*]
  }

  dimension: email_address {
    type: string
    sql: ${TABLE}.email_address ;;
    drill_fields: [sheet_client*]
  }

  dimension: format {
    type: string
    sql: ${TABLE}.Format ;;
    drill_fields: [sheet_client*]
  }

  dimension: optin_email {
    type: string
    sql: ${TABLE}.optin_email ;;
    drill_fields: [sheet_client*]
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
    drill_fields: [sheet_client*]
  }

  dimension: type_camp {
    type: string
    sql: CASE
         WHEN ${camp_name} LIKE 'Trigger%'
         THEN 'Trigger'
         END ;;
  }


  measure: count {
    type: count
    drill_fields: [sheet_client*]
      }

  measure: count_volume_email {
    type: count_distinct
    drill_fields: [sheet_client*]
    sql: ${TABLE}.email_address ;;
    }

  measure: count_volume_email_recu {
    type: count_distinct
    drill_fields: [sheet_client*]
    sql: CASE
         WHEN ${dt_bounce_date} is null
         THEN ${TABLE}.email_address
         END;;
  }

  measure: count_volume_bounce {
    type: count_distinct
    drill_fields: [sheet_client*]
    sql: CASE
         WHEN ${dt_bounce_date} is not null
         THEN ${TABLE}.email_address
         END;;
  }

  measure: count_volume_click{
    type: count_distinct
    drill_fields: [sheet_client*]
    sql: CASE
         WHEN ${dt_click_date} is not null
         THEN ${TABLE}.email_address
         END;;
  }

  measure: count_volume_open{
    type: count_distinct
    drill_fields: [sheet_client*]
    sql: CASE
           WHEN ${dte_open_date} is not null
           THEN ${TABLE}.email_address
           END;;
    }

  measure: count_volume_desabo{
    type: count_distinct
    drill_fields: [sheet_client*]
    sql: CASE
           WHEN ${dt_unsub_date} is not null
          THEN ${TABLE}.email_address
           END;;
   }

  measure: taux_bounce{
    type: number
    drill_fields: [sheet_client*]
    sql:  case when ${count_volume_email_recu} !=0
          then (${count_volume_bounce}/${count_volume_email_recu}) end   ;;
  }

  measure: taux_desabo{
    type: number
    drill_fields: [sheet_client*]
    sql:  case when ${count_volume_email_recu} !=0
          then  (${count_volume_desabo}/${count_volume_email_recu}) end  ;;
  }

  measure: taux_ouvreur{
    type: number
    drill_fields: [sheet_client*]
    sql: case when ${count_volume_email_recu} !=0
          then (${count_volume_open}/${count_volume_email_recu}) end   ;;
  }

  measure: taux_cliqueur{
    type: number
    drill_fields: [sheet_client*]
    sql: case when ${count_volume_email_recu} !=0
          then (${count_volume_click}/${count_volume_email_recu}) end  ;;
  }

  measure: percent_of_column{
    type: percent_of_total
    drill_fields: [sheet_client*]
    sql:  ${count_volume_bounce} ;;
  }

  measure: taux_reactivite{
    type: number
    drill_fields: [sheet_client*]
    sql:  case when ${count_volume_open} != 0
                  then ${count_volume_click}/${count_volume_open}
                  end;;
  }

  set: sheet_client {
    fields: [camp_id,camp_name, dte_open_date,dt_click_date,dt_unsub_date ,dt_bounce_date ,bounce_type, category_id,category_name,customer_id,email_address,type_client,optin_email]
  }
}
