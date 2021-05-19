view: pdt_famille {
  derived_table: {
    sql: SELECT distinct
       a.c_article as article,
       a.c_fournisseur as cd_fournisseur,
       a.c_marque as cd_marque,
       art.c_noeud as noeud,
       art.c_arbre as arbre,
       n4.Niveau4 as Niveau_4,
       n3.SousFamille as N3_SS_Famille,
       n2.Famille as N2_Famille,
       n1.Division as N1_Division,
       b.Nom_TBE as NOM,
       b.Type_TBE as Typ ,
       b.DATE_OUV as Dte_Ouverture,
       b.Pays_TBE as Pays ,
       b.Region as Region ,
       b.SURF_VTE as Surface ,
       b.TYP_MAG as TYP_MAG,
       b.Tranche_age as Anciennete,
       b.CD_Magasin as CD_Magasin,
       b.CD_Article,
       b.Dte_Vte as Dte_Vte,
       b.Typ_Vente as Typ_Vente ,
       b.Qtite as Qtite,
       b.ca_ht as ca_ht,
       b.marge_brute as marge_brute,
       w.methode_livraison,
       w.Canal_commande,
       w.statut,
       w.Total_HT,
       w.Tarif_HT_livraison


FROM  (`bv-prod.Matillion_Perm_Table.ARTICLE_DWH` a

LEFT JOIN `bv-prod.Matillion_Perm_Table.ART_ARBO_DWH` art

ON art.c_article = a.c_Article

LEFT JOIN `bv-prod.Matillion_Perm_Table.N4`  n4

ON n4.ID_N4_N4 = art.c_noeud

LEFT JOIN `bv-prod.Matillion_Perm_Table.N3_SS_Famille` n3

ON n3.ID_N3_SSFAMILLE = n4.ID_N3_SSFAMILLE

LEFT JOIN `bv-prod.Matillion_Perm_Table.N2_Famille` n2

ON n2.ID_N2_FAMILLE = n3.ID_N2_FAMILLE

LEFT JOIN `bv-prod.Matillion_Perm_Table.N1_Division` n1

ON n1.ID_N1_DIVISION = n2.ID_N1_DIVISION)


LEFT JOIN  (

SELECT
       Nom_TBE,
       Type_TBE ,
       DATE_OUV,
       Pays_TBE,
       Region ,
       SURF_VTE,
       TYP_MAG ,
       Tranche_age ,
       CD_Magasin ,
       CD_Article,
       Dte_Vte ,
       Typ_Vente  ,
       Qtite ,
       ca_ht ,
       marge_brute


       FROM `bv-prod.Matillion_Perm_Table.Magasins` m

       LEFT JOIN

       (select
        RIGHT(CONCAT('000', CD_Site_Ext),3)  as CD_Site_Ext ,
        Dte_Vte ,
        Typ_Vente ,
        CD_Article,
        sum(Val_Achat_Gbl) as Val_Achat_Gbl ,
        sum(Qtite) as Qtite ,
        sum(ca_ht) as ca_ht ,
        sum(marge_brute) as marge_brute
      from `bv-prod.Matillion_Perm_Table.TF_VENTE`
      group by 1,2,3,4

      UNION ALL

select
        RIGHT(CONCAT('000', CD_SITE_EXT),3)  as CD_Site_Ext ,
        DTE_VENTE ,
        TYP_VENTE ,
        ID_ARTICLE,
        sum(VAL_ACHAT_GBL) as Val_Achat_Gbl ,
        sum(QTITE) as Qtite ,
        sum(CA_HT) as ca_ht,
        sum(MARGE_BRUTE) as marge_brute
      from `bv-prod.Matillion_Perm_Table.GOOGLE_SHEET`
      group by 1,2,3,4

      ) v

       ON m.cd_logiciel = v.CD_Site_Ext ) b


       ON b.CD_Article = a.c_Article


       LEFT JOIN

       (
       SELECT
cd_produit,
dte_commande,
cd_magasin,
methode_livraison,
Canal_commande,
statut,
sum(Total_HT) as Total_HT,
sum(Tarif_HT_livraison) as Tarif_HT_livraison
from `bv-prod.Matillion_Perm_Table.Produit_Commande` p
inner join `bv-prod.Matillion_Perm_Table.COMMANDES` c
on p.cd_commande=CAST(c.cd_commande AS INT64 )
group by 1,2,3,4,5,6
       ) w

       ON  w.cd_produit = a.c_article
       AND w.dte_commande = b.Dte_Vte
       AND w.cd_magasin = b.CD_Magasin
 ;;
    persist_for: "24 hours"
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: article {
    type: string
    sql: ${TABLE}.article ;;
  }

  dimension: cd_fournisseur {
    type: string
    sql: ${TABLE}.cd_fournisseur ;;
  }

  dimension: cd_marque {
    type: string
    sql: ${TABLE}.cd_marque ;;
  }

  dimension: noeud {
    type: number
    sql: ${TABLE}.noeud ;;
  }

  dimension: arbre {
    type: number
    sql: ${TABLE}.arbre ;;
  }

  dimension: niveau_4 {
    type: string
    sql: ${TABLE}.Niveau_4 ;;
  }

  dimension: n3_ss_famille {
    type: string
    sql: ${TABLE}.N3_SS_Famille ;;
  }

  dimension: n2_famille {
    type: string
    sql: ${TABLE}.N2_Famille ;;
  }

  dimension: n1_division {
    type: string
    sql: ${TABLE}.N1_Division ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
  }

  dimension: typ {
    type: string
    sql: ${TABLE}.Typ ;;
  }

  dimension_group: dte_ouverture {
    type: time
    timeframes: [
      raw,
      date,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Dte_Ouverture ;;
  }

  dimension_group: dte_vte {
    type: time
    timeframes: [
      raw, date, week, month, month_name, quarter, year,
      fiscal_month_num, fiscal_quarter, fiscal_quarter_of_year, fiscal_year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Dte_Vte ;;
  }

  dimension: pays {
    type: string
    sql: ${TABLE}.Pays ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
  }

  dimension: surface {
    type: number
    sql: ${TABLE}.Surface ;;
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
  }

  dimension: anciennete {
    type: string
    sql: ${TABLE}.Anciennete ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
  }

  dimension: cd_article {
    type: string
    sql: ${TABLE}.CD_Article ;;
  }


  dimension: typ_vente {
    type: number
    sql: ${TABLE}.Typ_Vente ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.Qtite ;;
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.ca_ht ;;
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.marge_brute ;;
  }

  dimension: methode_livraison {
    type: string
    sql: ${TABLE}.methode_livraison ;;
  }

  dimension: canal_commande {
    type: string
    sql: ${TABLE}.Canal_commande ;;
  }

  dimension: statut {
    type: string
    sql: ${TABLE}.statut ;;
  }

  dimension: total_ht {
    type: number
    sql: ${TABLE}.Total_HT ;;
  }

  dimension: tarif_ht_livraison {
    type: number
    sql: ${TABLE}.Tarif_HT_livraison ;;
  }

  set: detail {
    fields: [
      article,
      cd_fournisseur,
      cd_marque,
      noeud,
      arbre,
      niveau_4,
      n3_ss_famille,
      n2_famille,
      n1_division,
      nom,
      typ,
      pays,
      region,
      surface,
      typ_mag,
      anciennete,
      cd_magasin,
      cd_article,
      typ_vente,
      qtite,
      ca_ht,
      marge_brute,
      methode_livraison,
      canal_commande,
      statut,
      total_ht,
      tarif_ht_livraison
    ]
  }
}
