<g:if test="${juiciosDelActor}">
    <table style="width:100%;font-size: 11px;" id="acuerdosJuicio" class="table table-hover">
        <thead>
            <tr>
                <th style="width: 15%; text-align: center;">Expediente Interno</th>
                <th style="width: 15%; text-align: center;">Estado</th>
                <th style="width: 15%; text-align: center;">Delegación</th>
                <th style="width: 15%; text-align: center;">Despacho</th>
                <th style="width: 20%;text-align: center;">Tipo de Parte</th>
            </tr>
        </thead>
        <tbody>
            <g:each var='juicio' in='${juiciosDelActor}'>
                <tr>
                    <td style="width: 15%;  text-align: center;"><g:link class="btn btn-success btn-xs" action="show" controller="juicio" id="${juicio.juicio.id}">${juicio.juicio.expedienteInterno}</g:link></td>
                    <td style="width: 15%;  text-align: center;">${juicio.juicio.estadoDeJuicio}</td>
                    <td style="width: 15%;  text-align: center;">${juicio.juicio.delegacion.nombre}</td>
                    <td style="width: 15%;  text-align: center;">${juicio.juicio.despacho}</td>
                    <td style="width: 20%; text-align: center;">${juicio.tipoDeParte}</td>
                </tr>
            </g:each> 
        </tbody>
    </table>
</g:if>
<g:else>
    El actor no está registrado en ningún asunto.
</g:else>