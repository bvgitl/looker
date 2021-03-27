connection: "bigquery_prod"

# include all the views
include: "/views/**/*.view"
# include: "dashboards/*.dashboard.lookml"
fiscal_month_offset: 3

datagroup: bv_vente_datagroup {
  sql_trigger: SELECT count(*) FROM tf_vente ;;
  max_cache_age: "24 hour"
}

datagroup: bv_vente_digitale_datagroup {
   sql_trigger: SELECT count(*) FROM commandes ;;
  max_cache_age: "24 hour"
}

persist_with: bv_vente_datagroup


explore: pdt_vente {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${pdt_vente.cd_site_ext}=${magasins.cd_comptable} ;;
    fields: [magasins.cd_magasin, magasins.nom, magasins.region, magasins.animateur, magasins.franchise, magasins.typ_mag, magasins.date_ouv_date, magasins.surf_vte]
  }
  join: pdt_commandes_digitales {
    type: left_outer
    relationship: one_to_one
    sql_on: ${magasins.cd_magasin}=${pdt_commandes_digitales.cd_magasin} ;;
  }
}

explore: pdt_commandes_digitales {
  persist_with: bv_vente_digitale_datagroup
}

explore: tf_vente {
  label: "Data Quality"
  join: tf_vente_mag {
    type: left_outer
    relationship: many_to_one
    sql_on: ${tf_vente.cd_site_ext}=${tf_vente_mag.cd_site_ext} ;;
  }
}

explore: tf_vente_mag {}

explore: ventes_devise {}

explore: commandes {}

explore: magasins {}
