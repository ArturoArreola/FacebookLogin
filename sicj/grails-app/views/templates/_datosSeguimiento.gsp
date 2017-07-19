<table style="width: 100%;" class="table">
    <thead>
        <tr>
            <th colspan="6"><h4>Datos del Asunto</h4></th>
        </tr>   
    <thead>    
    <tbody style="font-size: 14px;">
        <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 3 || (juicio.materia.id == 4 && juicio.tipoDeProcedimiento.id == 23)}">    
            <g:if test="${notificacionJuicioCantidad > 0}" > 
                <g:each var='mensaje' in='${notificacionJuicio}'>
                    
                    <input type="hidden" name="mensajeNotificacionJuicio" id="mensajeNotificacionJuicio" value="${notificacionJuicioCantidad}">
                    <input type="hidden" name="notificacionJuicio" id="notificacionJuicio" value="${mensaje.textoNotificacion}">
                </g:each>
            </g:if>
            <tr>
                <th style="text-align: right; vertical-align: middle;">Materia:</th>
                <td style="vertical-align: middle; max-width: 20%;width: 20%;">${juicio.materia}</td>
                <th style="text-align: right; vertical-align: middle;">Ámbito:</th>
                <td style="vertical-align: middle;">${juicio.ambito}</td>
                <th style="text-align: right; vertical-align: middle;">
                    <button class="btn btn-warning btn-xs" type="button" data-toggle="tooltip" data-placement="top" title="Ver Historial Completo" onclick="obtenerBitacora(${juicio.id})"><i class="fa fa-history"></i></button>
                        Estatus:
                </th>
                <td style="vertical-align: middle;">
                    <% def colores = ["#fa9d4b","#1ab394","#79d2c0","#d54545","#bf00ff","#45c6d5","#848484"] %>
                    <span  class="badge" style="width: 100%; color: #FFFFFF; background-color: ${colores.getAt((juicio.estadoDeJuicio.id as int) -1)};">
                        <strong>${juicio.estadoDeJuicio}</strong>
                    </span>
                </td>
            </tr>
            <tr>
                <th style="text-align: right; vertical-align: middle;">Delegación:</th>
                <td style="vertical-align: middle;">${juicio.delegacion}</td>
                <th style="text-align: right; vertical-align: middle;">Tipo de Juicio:</th>
                <td style="vertical-align: middle;">${juicio.tipoDeProcedimiento}</td>
                <th style="text-align: right; vertical-align: middle;">Etapa Procesal:</th>
                <td style="vertical-align: middle;">${(juicio.etapaProcesal)?: "WF SIN CONTESTAR"}</td>
            </tr>
            <tr>
                <th style="text-align: right; vertical-align: middle;">Gerente Jurídico:</th>
                <td style="vertical-align: middle;">${gerenteJuridico}</td>
                <th style="text-align: right; vertical-align: middle;">Tipo de Parte:</th>
                <td style="vertical-align: middle;">${juicio.tipoDeParte}</td>
                <th style="text-align: right; vertical-align: middle;">Elaborado Por:</th>
                <td style="vertical-align: middle;">${juicio.creadorDelCaso}</td>
            </tr>
            <tr>
                <th style="text-align: right; vertical-align: middle;">Resp. del Juicio:</th>
                <td style="vertical-align: middle;">${juicio.responsableDelJuicio}</td>
                <th style="text-align: right; vertical-align: middle;">Expediente Interno</th>
                <td style="vertical-align: middle;">${juicio.expedienteInterno}</td>
                <th style="text-align: right; vertical-align: middle;">Fecha de Alta:</th>
                <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${juicio.fechaDeCreacion}"/></td>
            </tr>
            <tr>
                <th style="text-align: right; vertical-align: middle;">División:</th>
                <td style="vertical-align: middle;">${juicio.delegacion.division}</td>
                <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}">
                    <th style="text-align: right; vertical-align: middle;">Expediente de Juicio:</th>
                    </g:if>
                    <g:else>
                        <g:if test="${prestacionReclamada?.getAt(0)?.id == 1}">
                        <th style="text-align: right; vertical-align: middle;">Núm. de Acta Especial:</th>
                        </g:if>
                        <g:elseif test="${prestacionReclamada?.getAt(0)?.id == 2}">
                        <th style="text-align: right; vertical-align: middle;">Núm. de Averiguación Previa:</th>
                        </g:elseif>
                        <g:elseif test="${prestacionReclamada?.getAt(0)?.id == 3}">
                        <th style="text-align: right; vertical-align: middle;">Núm. de Carpeta de Investigación:</th>
                        </g:elseif>
                        <g:elseif test="${prestacionReclamada?.getAt(0)?.id == 4}">
                        <th style="text-align: right; vertical-align: middle;">Núm. de Noticia Criminal:</th>
                        </g:elseif>
                    </g:else>
                <td style="vertical-align: middle;">${juicio.expediente}</td>
                <th style="text-align: right; vertical-align: middle;">Fecha de Modificación:</th>
                <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${juicio.ultimaModificacion}"/></td>
            </tr>
            <tr>
                <th style="text-align: right; vertical-align: middle;">Región:</th>
                <td style="vertical-align: middle;">${juicio.region}</td>
                <th style="text-align: right; vertical-align: middle;">Provisión:</th>
                <td style="vertical-align: middle;"><g:if test="${juicio.estadoDeJuicio.id == 1 || juicio.estadoDeJuicio.id == 3 || juicio.estadoDeJuicio.id == 5}"><a data-toggle="tooltip" title="Cambiar provisión" onclick="mostrarModal('modalCambiarProvision');"></g:if>
                        <span  class="badge                              
                        <g:if test="${juicio.provision.id == 1}"> badge-danger"></g:if>
                        <g:if test="${juicio.provision.id == 2}"> badge-primary"></g:if>
                        <g:if test="${juicio.provision.id == 3}"> badge-warning"></g:if>
                        ${juicio.provision}</span></a></td>
                <th style="text-align: right; vertical-align: middle;">Modificado Por:</th>
                <td style="vertical-align: middle;">${juicio.personaQueModifico}</td>
            </tr>
            <tr>
                <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}"> 
                    <th style="text-align: right; vertical-align: middle;">Patrocinador:</th>
                    <td style="vertical-align: middle;">${juicio.patrocinadoDelJuicio}</td>
                </g:if>
                <g:elseif test="${juicio.materia.id == 3}">
                    <th style="text-align: right; vertical-align: middle;">Números de Crédito Relacionados con la Denuncia:</th>
                    <td style="vertical-align: middle;"><g:each var='numeroDeCredito' in='${numerosDeCredito}'><span class="badge badge-success">${numeroDeCredito}</span></g:each></td>
                    </g:elseif>
                    <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 3}">
                    <th style="text-align: right; vertical-align: middle;">Despacho:</th>
                    <td style="vertical-align: middle;">${juicio.despacho}</td>
                </g:if>
                <g:elseif test="${juicio.materia.id == 4}">
                    <th style="text-align: right; vertical-align: middle;">Despacho:</th>
                    <td style="vertical-align: middle;">${juicio.despacho}</td>
                </g:elseif>
                <th style="text-align: right; vertical-align: middle;">Fecha de Reactivación:</th>
                <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${controlJuicio.fechaDeReactivacion}"/></td>
            </tr>
            <tr>
                <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}"> 
                    <th style="text-align: right; vertical-align: middle;">Número de Crédito:</th>
                    <td style="vertical-align: middle;"><g:each var='numeroDeCredito' in='${numerosDeCredito}'><span class="badge badge-success">${numeroDeCredito}</span></g:each></td>
                    </g:if>
                    <g:elseif test="${juicio.materia.id == 3}">
                    <th style="text-align: right; vertical-align: middle;">Monto del Daño Patrimonial Denunciado:</th>
                    <td style="vertical-align: middle;"><g:formatNumber number="${juicio.monto}" format="\044###,##0"/></td>
                </g:elseif>
                <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 3}">
                    <th style="text-align: right; vertical-align: middle;">Responsable del Despacho:</th>
                    <td style="vertical-align: middle;">${responsableDelDespacho}</td>
                </g:if>
                <g:elseif test="${juicio.materia.id == 4}">
                    <th style="text-align: right; vertical-align: middle;">Proveedor Responsable:</th>
                    <td style="vertical-align: middle;">${proveedorResponsable}</td>
                </g:elseif>
                <th style="text-align: right; vertical-align: middle;">Reactivado Por:</th>
                <td style="vertical-align: middle;">${controlJuicio.reactivadoPor}</td>
            </tr>
            <tr>
                <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}"> 
                    <th style="text-align: right; vertical-align: middle;">Cantidad Demandada:</th>
                    <td style="vertical-align: middle;"><g:formatNumber number="${juicio.monto}" format="\044###,##0"/ type="currency" currencyCode="MXN"/></td>
                </g:if>
                <g:elseif test="${juicio.materia.id == 3}">
                    <th style="text-align: right; vertical-align: middle;">Cantidad Recuperada por Reparación del Daño:</th>
                    <td style="vertical-align: middle;"><g:formatNumber number="${juicio.monto}" format="\044###,##0"/ type="currency" currencyCode="MXN"/></td>
                </g:elseif>
                <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 3}">
                    <th style="text-align: right; vertical-align: middle;">Fecha de Envío al Despacho:</th>
                    </g:if>
                    <g:elseif test="${juicio.materia.id == 4}">
                    <th style="text-align: right; vertical-align: middle;">Fecha de Envío al Proveedor:</th>
                    </g:elseif>
                <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy" date="${juicio.fechaRD}" /></td>
                <th style="text-align: right; vertical-align: middle;">Fecha de Cancelación por Error:</th>
                <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${controlJuicio.fechaDeCancelacion}"/></td>
            </tr>
            <tr>
                <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}"> 
                    <th style="text-align: right; vertical-align: middle;">Pagado:</th>
                    <td style="vertical-align: middle;"><span class="badge <g:if test="${juicio.juicioPagado}">badge-primary"></g:if><g:else>badge-danger"></g:else>${(juicio.juicioPagado) ? "SI" : "NO" }</span></td>
                    <th style="text-align: right; vertical-align: middle;">Prestación Reclamada:
                    </g:if>
                    <g:elseif test="${juicio.materia.id == 3}">
                    <th style="text-align: right; vertical-align: middle;">Forma de Pago:</th>
                    <td style="vertical-align: middle;">${juicio.formaDePago}</td>
                    <th style="text-align: right; vertical-align: middle;">Tipo de Asignación:
                    </g:elseif>    
                </th>
                <td style="vertical-align: middle;">${prestacionReclamada?.getAt(0)}</td>
                <th style="text-align: right; vertical-align: middle;">Cancelado Por:</th>
                <td style="vertical-align: middle;">${controlJuicio.canceladoPor}</td>
            </tr>
            <tr>
                <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}"> 
                    <th style="text-align: right; vertical-align: middle;">Cantidad Pagada:</th>
                    <td style="vertical-align: middle;"><g:formatNumber number="${juicio.cantidadPagada}" format="\044###,##0"/ type="currency" currencyCode="MXN"/></td>
                    <th style="text-align: right; vertical-align: middle;">Tipos Asociados:</th>
                    <td style="vertical-align: middle;">
                        <g:each var='tipoAsociado' in='${tiposAsociadosJuicio}'>
                <li>${tipoAsociado}</li>
                </g:each>
        </td>
    </g:if>
    <g:elseif test="${juicio.materia.id == 3}">
        <th style="text-align: right; vertical-align: middle;">Ubicación del Inmueble:</th>
        <td style="vertical-align: middle;">
            <g:if test="${ubicacionDelInmueble}">
                <g:if test="${ubicacionDelInmueble.direccionCompleta}">
                    ${ubicacionDelInmueble.direccionCompleta}
                </g:if>
                <g:else>
                    ${ubicacionDelInmueble.calle}, 
                    Núm. Ext. ${ubicacionDelInmueble.numeroExterior}, 
                    Núm. Int. ${ubicacionDelInmueble.numeroInterior}, 
                    ${ubicacionDelInmueble.colonia}, 
                    ${ubicacionDelInmueble.municipio}, 
                    ${ubicacionDelInmueble.estado}, 
                    C.P. ${ubicacionDelInmueble.codigoPostal}
                </g:else>
            </g:if>
        </td>
        <th style="text-align: right; vertical-align: middle;">Delitos Denunciados:</th>
        <td style="vertical-align: middle;">
            <g:each var='delito' in='${delitosJuicio}'>
            <li>${delito}</li>
            </g:each>
    </td>
</g:elseif>
<th style="text-align: right; vertical-align: middle;">Fecha de WF Completado:</th>
<td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${controlJuicio.fechaDeWfTerminado}"/></td>
</tr>
<tr>
    <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}">
        <th style="text-align: right; vertical-align: middle;">Forma de Pago:</th>
        <td style="vertical-align: middle;">${juicio.formaDePago}</td>
        <th style="text-align: right; vertical-align: middle;">Actor(es):
        </g:if>
        <g:elseif test="${juicio.materia.id == 3}">
        <th style="text-align: right; vertical-align: middle;">Notas:</th>
        <td style="vertical-align: middle;">
            <div class="input-group">
                <g:if test="${juicio.estadoDeJuicio.id != 4 && juicio.estadoDeJuicio.id != 6 && juicio.estadoDeJuicio.id != 7}">
                    <button class="btn btn-primary btn-xs" type="button" data-toggle="tooltip" data-placement="top" title="Agregar Nota" onclick="$('#modalRegistrarNota').modal('show')"><i class="fa fa-plus"></i></button> &nbsp;
                    </g:if>
                <button class="btn btn-success btn-xs" type="button" data-toggle="tooltip" data-placement="top" title="Ver Notas" onclick="obtenerNotas(${juicio.id})"><i class="fa fa-list"></i></button>
            </div>
        </td>
        <th style="text-align: right; vertical-align: middle;">Denunciante(s):
        </g:elseif>    
    </th>
    <td style="vertical-align: middle;">
        <% def cantidadDeActores = 0 %>
        <g:each var='actor' in='${actores}'>
            <g:if test="${actor.tipoDeParte.id == 5 || actor.tipoDeParte.id == 6}">
                <g:if test="${cantidadDeActores < 5}">
            <li>${actor.persona}<g:if test="${actor.tipoDeParte.id == 5}"><br/>(NSS: ${actor.persona.numeroSeguroSocial}) <% cantidadDeActores++ %> </g:if></li>
            </g:if>  
        </g:if>
    </g:each>
<center><button type="button" class="btn-xs btn-default btn-bitbucket" onclick="mostrarListaCompleta(${juicio.id},'actores');"> <g:if test="${cantidadDeActores >= 5}"> Ver la lista completa / </g:if>Editar lista </button></center>
</td>
<th style="text-align: right; vertical-align: middle;">WF Completado Por:</th>
<td style="vertical-align: middle;">${controlJuicio.wfTerminadoPor}</td>
</tr>
<tr>
    <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}">
        <th style="text-align: right; vertical-align: middle;">
            Finado:
        </th>
        <td style="vertical-align: middle;">${(juicio.finado) ? "SI" : "NO" }</td>
        <th style="text-align: right; vertical-align: middle;">Demandado(s):
        </g:if>
        <g:elseif test="${juicio.materia.id == 3}">
        <th style="text-align: right; vertical-align: middle;">Subprocuraduría:</th>
        <td style="vertical-align: middle;">${juicio.subprocuraduria}</td>
        <th style="text-align: right; vertical-align: middle;">Probable(s) Responsable(s):
        </g:elseif>    
    </th>
    <td style="vertical-align: middle;">
        <g:each var='actor' in='${actores}'>
            <g:if test="${actor.tipoDeParte.id == 1 || actor.tipoDeParte.id == 2 || actor.tipoDeParte.id == 7}">
        <li>${actor.persona}</li>
        </g:if>
    </g:each>
</td>
<th style="text-align: right; vertical-align: middle;">Fecha de Termino:</th>
<td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy" date="${juicio.fechaDeTermino}"/></td>
</tr>
<tr>
    <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}">
        <th style="text-align: right; vertical-align: middle;">Nombre del Finado:</th>
        <td style="vertical-align: middle;">${juicio.nombreDelFinado}</td>
    </g:if>
    <g:elseif test="${juicio.materia.id == 3}">
        <th style="text-align: right; vertical-align: middle;">Unidad Especializada:</th>
        <td style="vertical-align: middle;">${juicio.unidadEspecializada}</td>
    </g:elseif>    
    <g:if test="${juicio.materia.id == 1}">
        <th style="text-align: right; vertical-align: middle;">Tercero(s) Interesado(s):</th>
        <td style="vertical-align: middle;">
            <g:each var='actor' in='${actores}'>
                <g:if test="${actor.tipoDeParte.id == 3}">
            <li>${actor.persona}</li>
            </g:if>
        </g:each>
</td>
</g:if>
<g:else>
    <th style="text-align: right; vertical-align: middle;">Municipio:</th>
    <td style="vertical-align: middle;">${juicio.municipioAutoridad}</td>
</g:else>    
<th style="text-align: right; vertical-align: middle;">Motivo de Termino:</th>
<td style="vertical-align: middle;">${juicio.motivoDeTermino}</td>
</tr>
<tr>
    <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}">
        <th style="text-align: right; vertical-align: middle;">NSS del Finado:</th>
        <td style="vertical-align: middle;">${juicio.numeroSeguroSocialDelFinado}</td>
    </g:if>
    <g:elseif test="${juicio.materia.id == 3}">
        <th style="text-align: right; vertical-align: middle;">Fiscalia:</th>
        <td style="vertical-align: middle;">${juicio.fiscalia}</td>
    </g:elseif>
    <g:if test="${juicio.materia.id == 1}">
        <th style="text-align: right; vertical-align: middle;">Municipio:</th>
        <td style="vertical-align: middle;">${juicio.municipioAutoridad}</td>
    </g:if>
    <g:else>
        <th style="text-align: right; vertical-align: middle;">Juzgado:</th>
        <td style="vertical-align: middle;">${juicio.autoridad?.tipoDeAutoridad}</td>
    </g:else>
    <th style="text-align: right; vertical-align: middle;">Terminado Por:</th>
    <td style="vertical-align: middle;">${juicio.terminadoPor}</td>
</tr>
<tr>
    <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}">
        <th style="text-align: right; vertical-align: middle;">RFC del Finado:</th>
        <td style="vertical-align: middle;">${juicio.rfcDelFinado}</td>
    </g:if>
    <g:elseif test="${juicio.materia.id == 3}">
        <th style="text-align: right; vertical-align: middle;">Mesa Investigadora:</th>
        <td style="vertical-align: middle;">${juicio.mesaInvestigadora}</td>
    </g:elseif>
    <g:if test="${juicio.materia.id == 1}">
        <th style="text-align: right; vertical-align: middle;">Juzgado:</th>
        <td style="vertical-align: middle;">${juicio.autoridad?.tipoDeAutoridad}</td>
    </g:if>
    <g:else>
        <th style="text-align: right; vertical-align: middle;">Autoridad<g:if test="${juicio.materia.id == 3}"> Ministerial Investigadora</g:if>:</th>
        <td style="vertical-align: middle;">${juicio.autoridad}</td>
    </g:else>
    <th style="text-align: right; vertical-align: middle;">Fecha de Registro de Termino:</th>
    <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${juicio.fechaRegistroDeTermino}"/></td>
</tr>
<tr>
    <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}">
        <th style="text-align: right; vertical-align: middle;">Ubicación del Inmueble:</th>
        <td style="vertical-align: middle;">
            <g:if test="${ubicacionDelInmueble}">
                <g:if test="${ubicacionDelInmueble.direccionCompleta}">
                    ${ubicacionDelInmueble.direccionCompleta}
                </g:if>
                <g:else>
                    ${ubicacionDelInmueble.calle}, 
                    Núm. Ext. ${ubicacionDelInmueble.numeroExterior}, 
                    Núm. Int. ${ubicacionDelInmueble.numeroInterior}, 
                    ${ubicacionDelInmueble.colonia}, 
                    ${ubicacionDelInmueble.municipio}, 
                    ${ubicacionDelInmueble.estado}, 
                    C.P. ${ubicacionDelInmueble.codigoPostal}
                </g:else>
            </g:if>
        </td>
    </g:if>
    <g:elseif test="${juicio.materia.id == 3}">
        <th style="text-align: right; vertical-align: middle;">Número de Causa Penal</th>
        <td style="vertical-align: middle;">${juicio.numeroDeCausaPenal}</td>
    </g:elseif>
    <g:if test="${juicio.materia.id == 1}">
        <th style="text-align: right; vertical-align: middle;">Autoridad:</th>
        <td style="vertical-align: middle;">${juicio.autoridad}</td>
    </g:if>
    <g:elseif test="${juicio.materia.id == 4}">
        <th style="text-align: right; vertical-align: middle;">Acreditado:</th>
        <td style="vertical-align: middle;">${juicio.acreditado}</td>
    </g:elseif>
    <g:elseif test="${juicio.materia.id == 3}">
        <th style="text-align: right; vertical-align: middle;">Juzgado Asignado:</th>
        <td style="vertical-align: middle;">${juicio.juzgadoAsignado}</td>
    </g:elseif>
    <g:else>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
    </g:else>  
    <th style="text-align: right; vertical-align: middle;">Fecha de Archivo Definitivo:</th>
    <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${controlJuicio.fechaDeArchivoDefinitivo}"/></td>
</tr>
<tr>
    <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}">
        <th style="text-align: right; vertical-align: middle;">Notas:</th>
        <td style="vertical-align: middle;">
            <div class="input-group">
                <g:if test="${juicio.estadoDeJuicio.id != 4 && juicio.estadoDeJuicio.id != 6 && juicio.estadoDeJuicio.id != 7}">
                    <button class="btn btn-primary btn-xs" type="button" data-toggle="tooltip" data-placement="top" title="Agregar Nota" onclick="$('#modalRegistrarNota').modal('show')"><i class="fa fa-plus"></i></button> &nbsp;
                    </g:if>
                <button class="btn btn-success btn-xs" type="button" data-toggle="tooltip" data-placement="top" title="Ver Notas" onclick="obtenerNotas(${juicio.id})"><i class="fa fa-list"></i></button>
            </div>
        </td>
    </g:if>
    <g:elseif test="${juicio.materia.id == 3}">
        <th style="text-align: right; vertical-align: middle;">Agencia</th>
        <td style="vertical-align: middle;">${juicio.agencia}</td>
    </g:elseif>
    <g:if test="${juicio.materia.id == 4}">
        <th style="text-align: right; vertical-align: middle;">Año del Crédito</th>
        <td style="vertical-align: middle;">${juicio.anioDelCredito}</td>
    </g:if>
    <g:elseif test="${juicio.materia.id == 1}">
        <th style="text-align: right; vertical-align: middle;">¿En dónde está radicado el juicio?</th>
        <td style="vertical-align: middle;">${juicio.radicacionDelJuicio?.nombre}</td>
    </g:elseif>
    <g:elseif test="${juicio.materia.id == 1 || juicio.materia.id == 2}">
        <th style="text-align: right; vertical-align: middle;">Autoridad Migrada:</th>
        <td style="vertical-align: middle;">${juicio.juzgadoAsignado}</td>
    </g:elseif>
    <g:else>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
    </g:else>
    <th style="text-align: right; vertical-align: middle;">Archivado Por:</th>
    <td style="vertical-align: middle;">${controlJuicio.archivadoPor}</td>
</tr>
<tr>
    <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2}">
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
    </g:if>
    <g:elseif test="${juicio.materia.id == 3}">
        <th style="text-align: right; vertical-align: middle;">Otros</th>
        <td style="vertical-align: middle;">${juicio.otraInstancia}</td>
    </g:elseif>
    <g:elseif test="${juicio.materia.id == 4}">
        <th style="text-align: right; vertical-align: middle;">Registrar Pago</th>
        <td style="vertical-align: middle;">
            <div class="input-group">
                <g:if test="${juicio.estadoDeJuicio.id != 4 && juicio.estadoDeJuicio.id != 6 && juicio.estadoDeJuicio.id != 7}">
                    <button class="btn btn-success btn-xs" type="button" data-toggle="tooltip" data-placement="top" title="Agregar Pago" onclick="$('#modalRegistrarPago').modal('show')"><i class="fa fa-usd"></i></button> &nbsp;
                    </g:if>
                <button class="btn btn-default btn-xs" type="button" data-toggle="tooltip" data-placement="top" title="Ver Pagos" onclick="$('#modalListaPagosRezago').modal('show')"><i class="fa fa-list"></i></button>
            </div>
        </td>
    </g:elseif>
    <th style="text-align: right; vertical-align: middle;"></th>
    <td style="vertical-align: middle;"></td>
    <th style="text-align: right; vertical-align: middle;">Fecha de Histórico:</th>
    <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${controlJuicio.fechaDeArchivoHistorico}"/></td>
</tr>
<tr>
    <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2 || juicio.materia.id == 4}">
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
    </g:if>
    <g:elseif test="${juicio.materia.id == 3}">
        <th style="text-align: right; vertical-align: middle;">Notario</th>
        <td style="vertical-align: middle;">${juicio.notario}</td>
    </g:elseif>
    <th style="text-align: right; vertical-align: middle;"></th>
    <td style="vertical-align: middle;"></td>
    <th style="text-align: right; vertical-align: middle;">Enviado a Histórico Por:</th>
    <td style="vertical-align: middle;">${controlJuicio.enviadoHistoricoPor}</td>
</tr>
<tr>
    <th style="text-align: right; vertical-align: middle;"></th>
    <td style="vertical-align: middle;"></td>
    <th style="text-align: right; vertical-align: middle;"></th>
    <td style="vertical-align: middle;"></td>
    <th style="text-align: right; vertical-align: middle;">Fecha de Última Actualización de Workflow:</th>
    <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${juicio.ultimaActualizacionWorkflow}"/></td>
</tr>
<tr>
    <th style="text-align: right; vertical-align: middle;"></th>
    <td style="vertical-align: middle;"></td>
    <th style="text-align: right; vertical-align: middle;"></th>
    <td style="vertical-align: middle;"></td>
    <th style="text-align: right; vertical-align: middle;">Última Actualización de Workflow Por:</th>
    <td style="vertical-align: middle;">${juicio.ultimaPersonaQueActualizoWorkflow}</td>
</tr>
</g:if>
<g:elseif test="${(juicio.materia.id == 4 && juicio.tipoDeProcedimiento.id == 24)}">
    <tr>
        <th style="text-align: right; vertical-align: middle;">Materia:</th>
        <td style="vertical-align: middle; max-width: 20%;width: 20%;">${juicio.materia}</td>
        <th style="text-align: right; vertical-align: middle;">Tipo de Juicio:</th>
        <td style="vertical-align: middle;">${juicio.tipoDeProcedimiento}</td>
        <th style="text-align: right; vertical-align: middle;">
            <button class="btn btn-warning btn-xs" type="button" data-toggle="tooltip" data-placement="top" title="Ver Historial Completo" onclick="obtenerBitacora(${juicio.id})"><i class="fa fa-history"></i></button>
                Estatus:
        </th>
        <td style="vertical-align: middle;">
            <% def colores = ["#fa9d4b","#1ab394","#79d2c0","#d54545","#bf00ff","#45c6d5","#848484"] %>
            <span  class="badge" style="width: 100%; color: #FFFFFF; background-color: ${colores.getAt((juicio.estadoDeJuicio.id as int) -1)};">
                <strong>${juicio.estadoDeJuicio}</strong>
            </span>
        </td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;">Delegación:</th>
        <td style="vertical-align: middle;">${juicio.delegacion}</td>
        <th style="text-align: right; vertical-align: middle;">Expediente Interno:</th>
        <td style="vertical-align: middle;">${juicio.expedienteInterno}</td>
        <th style="text-align: right; vertical-align: middle;">Etapa Procesal:</th>
        <td style="vertical-align: middle;">${(juicio.etapaProcesal)?: "WF SIN CONTESTAR"}</td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;">Gerente Jurídico:</th>
        <td style="vertical-align: middle;">${gerenteJuridico}</td>
        <th style="text-align: right; vertical-align: middle;">Proveedor Asignado:</th>
        <td style="vertical-align: middle;">${juicio.proveedor}</td>
        <th style="text-align: right; vertical-align: middle;">Elaborado Por:</th>
        <td style="vertical-align: middle;">${juicio.creadorDelCaso}</td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;">Resp. del Juicio:</th>
        <td style="vertical-align: middle;">${juicio.responsableDelJuicio}</td>
        <th style="text-align: right; vertical-align: middle;">Proveedor Responsable</th>
        <td style="vertical-align: middle;">${proveedorRersponsable}</td>
        <th style="text-align: right; vertical-align: middle;">Fecha de Alta:</th>
        <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${juicio.fechaDeCreacion}"/></td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;">División:</th>
        <td style="vertical-align: middle;">${juicio.delegacion.division}</td>
        <th style="text-align: right; vertical-align: middle;">Fecha de Envío al Proveedor:</th>
        <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy" date="${juicio.fechaRD}" /></td>
        <th style="text-align: right; vertical-align: middle;">Fecha de Modificación:</th>
        <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${juicio.ultimaModificacion}"/></td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;">Región:</th>
        <td style="vertical-align: middle;">${juicio.region}</td>
        <th style="text-align: right; vertical-align: middle;">Acreditado:</th>
        <td style="vertical-align: middle;">${juicio.acreditado}</td>
        <th style="text-align: right; vertical-align: middle;">Modificado Por:</th>
        <td style="vertical-align: middle;">${juicio.personaQueModifico}</td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;">Ubicación del Inmueble:</th>
        <td style="vertical-align: middle;">
            <g:if test="${ubicacionDelInmueble}">
                <g:if test="${ubicacionDelInmueble.direccionCompleta}">
                    ${ubicacionDelInmueble.direccionCompleta}
                </g:if>
                <g:else>
                    ${ubicacionDelInmueble.calle}, 
                    Núm. Ext. ${ubicacionDelInmueble.numeroExterior}, 
                    Núm. Int. ${ubicacionDelInmueble.numeroInterior}, 
                    ${ubicacionDelInmueble.colonia}, 
                    ${ubicacionDelInmueble.municipio}, 
                    ${ubicacionDelInmueble.estado}, 
                    C.P. ${ubicacionDelInmueble.codigoPostal}
                </g:else>
            </g:if>
        </td>
        <th style="text-align: right; vertical-align: middle;">Número de Crédito</th>
        <td style="vertical-align: middle;"><g:each var='numeroDeCredito' in='${numerosDeCredito}'><span class="badge badge-success">${numeroDeCredito}</span></g:each></td>
            <th style="text-align: right; vertical-align: middle;">Fecha de Reactivación:</th>
            <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${controlJuicio.fechaDeReactivacion}"/></td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;">Notas:</th>
        <td style="vertical-align: middle;">
            <div class="input-group">
                <g:if test="${juicio.estadoDeJuicio.id != 4 && juicio.estadoDeJuicio.id != 6 && juicio.estadoDeJuicio.id != 7}">
                    <button class="btn btn-primary btn-xs" type="button" data-toggle="tooltip" data-placement="top" title="Agregar Nota" onclick="$('#modalRegistrarNota').modal('show')"><i class="fa fa-plus"></i></button> &nbsp;
                    </g:if>
                <button class="btn btn-success btn-xs" type="button" data-toggle="tooltip" data-placement="top" title="Ver Notas" onclick="obtenerNotas(${juicio.id})"><i class="fa fa-list"></i></button>
            </div>
        </td>
        <th style="text-align: right; vertical-align: middle;">Año del Crédito:</th>
        <td style="vertical-align: middle;">${anioDelCredito}</td>
        <th style="text-align: right; vertical-align: middle;">Reactivado Por:</th>
        <td style="vertical-align: middle;">${controlJuicio.reactivadoPor}</td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;">Fecha de Cancelación por Error:</th>
        <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${controlJuicio.fechaDeCancelacion}"/></td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;">Cancelado Por:</th>
        <td style="vertical-align: middle;">${controlJuicio.canceladoPor}</td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;">Fecha de WF Completado:</th>
        <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${controlJuicio.fechaDeWfTerminado}"/></td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;">WF Completado Por:</th>
        <td style="vertical-align: middle;">${controlJuicio.wfTerminadoPor}</td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;">Fecha de Termino:</th>
        <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy" date="${juicio.fechaDeTermino}"/></td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>  
        <th style="text-align: right; vertical-align: middle;">Motivo de Termino:</th>
        <td style="vertical-align: middle;">${juicio.motivoDeTermino}</td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;">Terminado Por:</th>
        <td style="vertical-align: middle;">${juicio.terminadoPor}</td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;">Fecha de Registro de Termino:</th>
        <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${juicio.fechaRegistroDeTermino}"/></td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>   
        <th style="text-align: right; vertical-align: middle;">Fecha de Archivo Definitivo:</th>
        <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${controlJuicio.fechaDeArchivoDefinitivo}"/></td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;">Archivado Por:</th>
        <td style="vertical-align: middle;">${controlJuicio.archivadoPor}</td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;">Fecha de Histórico:</th>
        <td style="vertical-align: middle;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${controlJuicio.fechaDeArchivoHistorico}"/></td>
    </tr>
    <tr>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;"></th>
        <td style="vertical-align: middle;"></td>
        <th style="text-align: right; vertical-align: middle;">Enviado a Histórico Por:</th>
        <td style="vertical-align: middle;">${controlJuicio.enviadoHistoricoPor}</td>
    </tr>
</g:elseif>
</tbody>    
</table>