view: magasin_dwh_histo {
    sql_table_name: Matillion_perm_Table.Magasin_DWH_Histo ;;

    dimension_group: DateDebut {
      type: time
      timeframes: [
        raw,
        date
      ]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.ScdDateDebut ;;
    }

  dimension_group: DateFin {
    type: time
    timeframes: [
      raw,
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ScdDateFin ;;
  }

    dimension: CodeActeur {
      type: string
      sql: ${TABLE}.c_magasin ;;
    }

    dimension: Pays   {
      type: string
      sql: ${TABLE}.c_pays  ;;
    }

    dimension: Blanc {
      type: yesno
      sql: ${TABLE}.c_blanc ;;
    }

    dimension: CodeExterne {
      type: string
      sql: ${TABLE}.c_externe ;;
    }

  dimension: Parent {
    type: string
    sql: ${TABLE}.c_parent ;;
  }

  dimension: Forme {
    type: string
    sql: ${TABLE}.c_forme ;;
  }

  dimension: CodePostal {
    type: string
    sql: ${TABLE}.c_postal ;;
  }

  dimension: LibelleMagasin {
    type: string
    sql: ${TABLE}.l_magasin ;;
  }

  dimension: LibelleMagasinCourt {
    type: string
    sql: ${TABLE}.l_magasin_court ;;
  }

  dimension: Ville {
    type: string
    sql: ${TABLE}.l_ville ;;
  }

  dimension: Logiciel {
    type: string
    sql: ${TABLE}.c_logiciel ;;
  }

  dimension: Type {
    type: string
    sql: ${TABLE}.c_type ;;
  }

  dimension: Surface {
    type: number
    sql: ${TABLE}.n_surface ;;
  }

  }
