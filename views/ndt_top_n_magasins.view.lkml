view: ndt_top_n_magasins {

  derived_table: {
    explore_source: pdt_vente {
      bind_all_filters: yes
      column: nom { field: magasins.nom }
      column: sum_CA_select_mois {}
      column: cd_site_ext {}
      derived_column: ranking {
        sql: RANK() OVER (ORDER BY sum_CA_select_mois DESC) ;;
      }
    }
  }
  dimension: nom {
    label: "Nom Magasin"
  }

  dimension: sum_CA_select_mois {
    value_format_name: eur
    type: number
  }

  dimension: cd_site_ext {
    primary_key: yes
  }

  dimension: ranking  {
    type: number
    sql: ${TABLE}.ranking ;;
  }

  dimension: top_magasins {
    order_by_field: top_magasins_ranking
    type: string
    sql:

      CASE
        WHEN ${ranking} <= {% parameter parameters.top_n %} THEN ${cd_site_ext}
        ELSE 'Autres'
      END
    ;;
  }

  dimension: top_magasins_ranking {
    type: string
    sql:

    CASE
      WHEN ${ranking} <= {% parameter parameters.top_n %}
        THEN
          CASE
            WHEN ${ranking} < 10 THEN CONCAT('0',CAST(${ranking} AS STRING))
            ELSE CAST(${ranking} AS STRING)
          END
      ELSE 'Autres'
    END
    ;;

  }
}
