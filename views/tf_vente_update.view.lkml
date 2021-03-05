view: tf_vente_update {
  derived_table: {
    sql: select
      m.CD_MAGASIN,
      m.NOM,
      m.TYP_MAG,
      m.DATE_OUV,
      m.SURF_VTE,
      m.CD_PAYS,
      v.ID_ARTICLE,
      v.DTE_VENTE,
      v.STATUT_ARTICLE,
      v.TYP_ARTICLE,
      v.TYP_VENTE,
      sum(v.VAL_ACHAT_GBL) as VAL_ACHAT_GBL,
      sum(v.QTITE) as QTITE,
      sum(v.CA_HT) as CA_HT,
      sum(v.MARGE_BRUTE) as MARGE_BRUTE,
      sum(v.NB_TICKET) as NB_TICKET
      from ods.tf_vente v
      left join magasin m
      on v.ID_MAGASIN = m.ID_MAGASIN
      group by 1,2,3,4,5,6,7,8,9,10,11
UNION ALL
select * FROM ods.google_sheet
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_MAGASIN ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
  }

  dimension_group: date_ouv {
    type: time
    datatype: datetime
    sql: ${TABLE}.DATE_OUV ;;
  }

  dimension: surf_vte {
    type: number
    sql: ${TABLE}.SURF_VTE ;;
  }

  dimension: cd_pays {
    type: string
    sql: ${TABLE}.CD_PAYS ;;
  }

  dimension: id_article {
    type: number
    sql: ${TABLE}.ID_ARTICLE ;;
  }

  dimension_group: dte_vente {
    type: time
    timeframes: [date, week, week_of_year ,month, month_name , year, raw, fiscal_month_num, fiscal_quarter, fiscal_quarter_of_year, fiscal_year]
    datatype: date
    sql: ${TABLE}.DTE_VENTE ;;
  }

  dimension: statut_article {
    type: string
    sql: ${TABLE}.STATUT_ARTICLE ;;
  }

  dimension: typ_article {
    type: string
    sql: ${TABLE}.TYP_ARTICLE ;;
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.TYP_VENTE ;;
  }

  dimension: val_achat_gbl {
    type: number
    sql: ${TABLE}.VAL_ACHAT_GBL ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.QTITE ;;
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.CA_HT ;;
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.MARGE_BRUTE ;;
  }

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.NB_TICKET ;;
  }

  filter: date_filter {
    label: "Période"
    type: date
  }

  filter: date_filter_3 {
    label: "Période n-3"
    type: date
  }

  dimension_group: diff_date {
    type: duration
    intervals: [year]
    sql_start: ${date_ouv_date::datetime} ;;
    sql_end: {% date_end date_filter %} ;;
  }

  dimension: categorie {
    label: "Catégorie"
    sql:
        CASE
          WHEN ${typ_mag} = "S" THEN "P. non comparable"
          ELSE (
            CASE
              WHEN ${date_ouv_raw} < CAST({% date_start date_filter_3 %} AS DATETIME) THEN "P.Comparable"
              ELSE "P. non Comparable"
            END )
        END
     ;;
  }

  dimension: anciennete {
    label: "Ancienneté"
    sql:
        CASE
          WHEN  ${years_diff_date} <= 2 THEN "A≤2 ans"
          WHEN  ${years_diff_date}  <= 5 AND ${years_diff_date} > 2 THEN "2 ans<A≤ 5 ans"
          WHEN  ${years_diff_date}  <= 10 AND ${years_diff_date}  > 5 THEN "5 ans<A≤10 ans"
          WHEN  ${years_diff_date}  > 10 THEN "A>10 ans"
        END
      ;;
  }

  set: detail {
    fields: [
      cd_magasin,
      nom,
      typ_mag,
      date_ouv_time,
      surf_vte,
      cd_pays,
      id_article,
      statut_article,
      typ_article,
      typ_vente,
      val_achat_gbl,
      qtite,
      ca_ht,
      marge_brute,
      nb_ticket
    ]
  }
}
