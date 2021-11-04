view: anciennete_mois {
  derived_table: {
    sql: WITH anciennete_mois AS (SELECT
          CASE
        WHEN ref_client_mag.anciennete_mois < 0.0 THEN '< 0'
        WHEN ref_client_mag.anciennete_mois < 3.0 THEN '[0 , 3]'
        WHEN ref_client_mag.anciennete_mois < 6.0 THEN '[3, 6]'
        WHEN ref_client_mag.anciennete_mois < 12.0 THEN '[6, 12]'
        WHEN ref_client_mag.anciennete_mois < 24.0 THEN '[12, 24]'
        WHEN ref_client_mag.anciennete_mois < 36.0 THEN '[24, 36]'
        ELSE '> 36'
      END
       AS Anciennete_par_mois,
          COUNT(*) AS ref_client_mag_count
      FROM `bv-prod.looker_pg.ref_client_mag`
           AS ref_client_mag
      GROUP BY
          1
      LIMIT 500
       )
SELECT
    anciennete_mois.ref_client_mag_count  AS Volume,
    anciennete_mois.Anciennete_par_mois  AS Anciennete_par_mois,
    case
        WHEN Anciennete_par_mois = '< 0' then 1
        WHEN Anciennete_par_mois = '[0 , 3]' then 2
        WHEN Anciennete_par_mois = '[3, 6]' then 3
        WHEN Anciennete_par_mois = '[6, 12]' then 4
        WHEN Anciennete_par_mois = '[12, 24]' then 5
        WHEN Anciennete_par_mois = '[24, 36]' then 6
        WHEN Anciennete_par_mois  = '> 36' then 7
        end as tri
FROM anciennete_mois
GROUP BY
    1,
    2
ORDER BY
    tri
LIMIT 500
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: volume {
    type: number
    sql: ${TABLE}.Volume ;;
  }

  dimension: anciennete_par_mois {
    type: string
    sql: ${TABLE}.Anciennete_par_mois ;;
  }

  dimension: tri {
    type: number
    sql: ${TABLE}.tri ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
    #drill_fields: [sheet_client*]
  }

  dimension: civilite {
    type: string
    sql: ${TABLE}.civilite ;;
    #drill_fields: [sheet_client*]
  }

  dimension: customer_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.customer_id ;;
    #drill_fields: [sheet_client*]
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
    sql: cast(${TABLE}.date_creation as TIMESTAMP) ;;
    #drill_fields: [sheet_client*]
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    #drill_fields: [sheet_client*]
  }

  dimension: format {
    type: string
    sql: ${TABLE}.Format ;;
    #drill_fields: [sheet_client*]
  }

  dimension: latitude {
    type: string
    sql: ${TABLE}.Latitude ;;
    #drill_fields: [sheet_client*]
  }

  dimension: longitude {
    type: string
    sql: ${TABLE}.Longitude ;;
    #drill_fields: [sheet_client*]
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
    #drill_fields: [sheet_client*]
  }

  dimension: optin_email {
    type: string
    sql: ${TABLE}.optin_email ;;
    #drill_fields: [sheet_client*]
  }

  dimension: optin_sms {
    type: string
    sql: ${TABLE}.optin_sms ;;
    #drill_fields: [sheet_client*]
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
    #drill_fields: [sheet_client*]
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
    #drill_fields: [sheet_client*]
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
    #drill_fields: [sheet_client*]
  }

  dimension: ville {
    type: string
    sql: ${TABLE}.Ville ;;
    #drill_fields: [sheet_client*]
  }

  set: detail {
    fields: [volume, anciennete_par_mois, tri]
  }
}
