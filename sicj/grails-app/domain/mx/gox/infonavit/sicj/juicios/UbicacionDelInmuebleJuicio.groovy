package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.catalogos.Estado
import mx.gox.infonavit.sicj.catalogos.Municipio

class UbicacionDelInmuebleJuicio implements Serializable {

    String calle
    String numeroExterior
    String numeroInterior
    String codigoPostal
    String colonia
    Estado estado
    Municipio municipio
    Juicio juicio
    String direccionCompleta
    
    static constraints = {
        calle (nullable:true)
        numeroExterior (nullable:true)
        numeroInterior (nullable:true)
        colonia (nullable:true)
        codigoPostal (nullable:true)
        estado (nullable:true)
        municipio (nullable:true)
        juicio (nullable:false)
        direccionCompleta (nullable:true)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_ubicacion_del_inmueble', params:[sequence:'ubicacion_del_inmueble_id_seq']
    }
    
    String toString () {
        direccionCompleta ?: "${calle} ${numeroExterior}, ${colonia}, ${codigoPostal}, ${municipio}, ${estado}"
    }
}
