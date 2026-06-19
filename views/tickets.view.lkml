view: tickets {
  sql_table_name: `bv-prod.Matillion_Perm_Table.Tickets` ;;

  dimension: app_sales_price_ht {
    type: number
    sql: ${TABLE}.app_sales_price_HT ;;
  }
  dimension: app_sales_price_ttc {
    type: number
    sql: ${TABLE}.app_sales_price_TTC ;;
  }
  dimension: c_magasin {
    type: string
    sql: ${TABLE}.c_magasin ;;
  }
  dimension: cd_article {
    type: string
    sql: ${TABLE}.CD_Article ;;
  }
  dimension: cd_niv_1 {
    type: number
    sql: ${TABLE}.CD_Niv_1 ;;
  }
  dimension: cd_niv_2 {
    type: number
    sql: ${TABLE}.CD_Niv_2 ;;
  }
  dimension: cd_niv_3 {
    type: number
    sql: ${TABLE}.CD_Niv_3 ;;
  }
  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }
  dimension: discount_no {
    type: string
    sql: ${TABLE}.discount_no ;;
  }
  dimension: discount_type {
    type: string
    sql: ${TABLE}.discount_type ;;
  }
  dimension_group: doc_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.doc_date ;;
  }
  dimension_group: doc_datetime {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.doc_datetime ;;
  }
  dimension: doc_no {
    type: string
    sql: ${TABLE}.doc_no ;;
  }
  dimension: doc_time {
    type: string
    sql: ${TABLE}.doc_time ;;
  }
  dimension: item_category {
    type: string
    sql: ${TABLE}.item_category ;;
  }
  dimension: item_status {
    type: string
    sql: ${TABLE}.item_status ;;
  }
  dimension: item_type {
    type: string
    sql: ${TABLE}.item_type ;;
  }
  dimension: line {
    type: number
    sql: ${TABLE}.line ;;
  }
  dimension: pamp {
    type: number
    sql: ${TABLE}.pamp ;;
  }
  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }
  dimension: sales_channel {
    type: string
    sql: ${TABLE}.sales_channel ;;
  }
  dimension: sales_type {
    type: number
    sql: ${TABLE}.sales_type ;;
  }
  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }
  dimension: std_sales_price_ht {
    type: number
    sql: ${TABLE}.std_sales_price_HT ;;
  }
  dimension: std_sales_price_ttc {
    type: number
    sql: ${TABLE}.std_sales_price_TTC ;;
  }
  dimension: web_order {
    type: string
    sql: ${TABLE}.web_order ;;
  }
  measure: count {
    type: count
  }
}
