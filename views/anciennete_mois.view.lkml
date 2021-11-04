view: anciennete_mois {
  derived_table: {
    sql: SELECT
          CASE
        WHEN ref_client_mag.anciennete_mois < 0.0 THEN '< 0'
        WHEN ref_client_mag.anciennete_mois < 3.0 THEN '1 - [0 , 3]'
        WHEN ref_client_mag.anciennete_mois < 6.0 THEN '2 - [3, 6]'
        WHEN ref_client_mag.anciennete_mois < 12.0 THEN '3 - [6, 12]'
        WHEN ref_client_mag.anciennete_mois < 24.0 THEN '4 - [12, 24]'
        WHEN ref_client_mag.anciennete_mois < 36.0 THEN '5 - [24, 36]'
        ELSE '6 - > 36'
      END
       AS Anciennete_par_mois,
          COUNT(*) AS ref_client_mag_count
      FROM `bv-prod.looker_pg.ref_client_mag`
           AS ref_client_mag
      GROUP BY
          1
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: anciennete_par_mois {
    type: string
    sql: ${TABLE}.Anciennete_par_mois ;;
  }

  dimension: ref_client_mag_count {
    type: number
    sql: ${TABLE}.ref_client_mag_count ;;
  }

  set: detail {
    fields: [anciennete_par_mois, ref_client_mag_count]
  }
}
