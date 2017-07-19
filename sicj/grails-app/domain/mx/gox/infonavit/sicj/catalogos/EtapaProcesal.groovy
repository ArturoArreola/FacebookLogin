package mx.gox.infonavit.sicj.catalogos

class EtapaProcesal implements Serializable{

    String nombre
    TipoDeProcedimiento tipoDeProcedimiento
    
    static constraints = {
        nombre (nullable:false)
        tipoDeProcedimiento (nullable:false)
    }
    
    static Set<EtapaProcesal> obtenerEtapas(long tipoDeProcedimientoId){
        def etapas = EtapaProcesal.executeQuery("Select ep From EtapaProcesal ep Where ep.tipoDeProcedimiento.id = " + tipoDeProcedimientoId)
        etapas
    }
    
    static Set<EtapaProcesalTipoDeParte> obtenerEtapas(long tipoDeProcedimientoId, long tipoDeParteId){
        def etapas = EtapaProcesal.executeQuery("Select eptp From EtapaProcesalTipoDeParte eptp, EtapaProcesal ep Where eptp.etapaProcesal.id = ep.id And ep.tipoDeProcedimiento.id = " + tipoDeProcedimientoId + " And eptp.tipoDeParte in (0," + tipoDeParteId + ")")
        etapas
    }
    
    static EtapaProcesal obtenerPrimerEtapa(long tipoDeProcedimientoId, long tipoDeParteId){
        def etapas = EtapaProcesal.executeQuery("Select ep From EtapaProcesalTipoDeParte eptp, EtapaProcesal ep Where eptp.etapaProcesal.id = ep.id And eptp.numeroSecuencial = 1 And ep.tipoDeProcedimiento.id = " + tipoDeProcedimientoId + " And eptp.tipoDeParte in (0," + tipoDeParteId + ")")
        etapas.get(0)
    }
    
    static int obtenerNumeroSecuencial(long etapaProcesalId, long tipoDeParteId){
        def etapa 
        if(etapaProcesalId > 0) {
            etapa = EtapaProcesalTipoDeParte.find("from EtapaProcesalTipoDeParte eptp where eptp.etapaProcesal.id = " + etapaProcesalId + " and eptp.tipoDeParte in (0," + tipoDeParteId + ")")
            etapa.numeroSecuencial
        } 
        else {
            return 0
        }
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_etapa_procesal', params:[sequence:'etapa_procesal_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
