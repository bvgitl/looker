view: vte_mag {
  derived_table: {
    sql: select
      v.id_tf_vte,
      m.CD_MAGASIN,
      m.NOM as magasin,
      m.TYP_MAG,
      m.DATE_OUV,
      m.SURF_VTE,
      m.CD_PAYS,
      v.DTE_VENTE,
      v.TYP_VENTE,
      v.STATUT_ARTICLE,
      sum(v.CA_HT) as ca_ht,
      sum(v.MARGE_BRUTE) as marge_brute,
      sum(v.NB_TICKET) as nb_clts,
      sum(v.QTITE) as qtite,
      sum(v.VAL_ACHAT_GBL) as couts
      from ods.tf_vente v
      left join magasin m
      on v.ID_MAGASIN = m.ID_MAGASIN
      group by 1,2,3,4,5,6,7,8,9,10
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id_tf_vte {
    primary_key: yes
    type: number
    sql: ${TABLE}.id_tf_vte ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_MAGASIN ;;
  }

  dimension: magasin {
    type: string
    sql: ${TABLE}.magasin ;;
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

  dimension_group: DTE_VENTE {
    type: time
    timeframes: [date, week, week_of_year ,month, month_name , year, raw, fiscal_month_num, fiscal_quarter, fiscal_quarter_of_year, fiscal_year]
    datatype: date
    sql: ${TABLE}.DTE_VENTE ;;
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.TYP_VENTE ;;
  }

  dimension: statut_article {
    type: string
    sql: ${TABLE}.STATUT_ARTICLE ;;
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.ca_ht ;;
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.marge_brute ;;
  }

  dimension: nb_clts {
    type: number
    sql: ${TABLE}.nb_clts ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.qtite ;;
  }

  dimension: couts {
    type: number
    sql: ${TABLE}.couts ;;
  }

  set: detail {
    fields: [
      cd_magasin,
      magasin,
      typ_mag,
      date_ouv_time,
      surf_vte,
      cd_pays,
      typ_vente,
      statut_article,
      ca_ht,
      marge_brute,
      nb_clts,
      qtite,
      couts
    ]
  }
}
