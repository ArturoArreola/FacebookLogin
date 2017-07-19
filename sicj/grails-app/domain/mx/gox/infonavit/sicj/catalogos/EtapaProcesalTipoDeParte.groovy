package mx.gox.infonavit.sicj.catalogos

class EtapaProcesalTipoDeParte implements Serializable{
    
    EtapaProcesal etapaProcesal
    TipoDeParte tipoDeParte
    int numeroSecuencial
    
    static constraints = {
        etapaProcesal (nullable: true)
        tipoDeParte (nullable: true)
    }
        
    static mapping = {
        id generator: 'sequence', column: 'id_etapa_procesal_tipo_de_parte', params:[sequence:'etapa_procesal_tipo_de_parte_id_seq']
    }
}
