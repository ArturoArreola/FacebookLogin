<g:if test="${audiencia}">
    <div class="col-lg-12">
        <div id="verAudiencia" class="row">
            <div class=" panel panel-primary">
                <div class="panel-heading">
                    Datos Generales de la Audiencia
                </div>
                <div class="panel-body">
                    <table style="width:100%;font-size: 11px;" class="table table-hover">
                        <thead>
                            <tr>
                                <th align="center">Expediente Interno</th>
                                <th align="center">Expediente del Juicio</th>
                                <th align="center">Autoridad</th>
                                <th align="center">Despacho</th>
                                <th align="center">Estatus</th>
                                <th align="center">Partes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>${juicio.expedienteInterno}</td>
                                <td>${juicio.expediente}</td>
                                <td>${juicio.autoridad}</td>
                                <td>${juicio.despacho}</td>
                                <td>${juicio.estadoDeJuicio}</td>
                                <td>
                                    <g:each var='parte' in='${partes}'>
                            <li><strong>${parte.persona}</strong> <span class="badge badge-info">${parte.tipoDeParte}</span></li>
                                </g:each>    
                        </td>
                        </tr>
                        <tr>
                            <th align="center">Fecha y Hora de Audiencia</th>
                            <th align="center">Litigante</th>
                            <th colspan="2" align="center">Tipo de Audiencia</th>
                            <th align="center">Acciones</th>
                            <th align="center">Resultado</th>
                        </tr>
                        <tr>
                            <td><g:formatDate format="dd/MM/yyyy" date="${audiencia.fechaDeAudiencia}"/></td>
                            <td>${audiencia.asistente}</td>
                            <td colspan="2">${audiencia.tipoDeAudiencia}</td>
                            <td>${audiencia.acciones}</td>
                            <td>${audiencia.resultado}</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div id="editarAudiencia" class="row" style="display:none;">
            <div class="col-md-12">
                <g:form class="form-horizontal" id="editarAudienciaForm" name="editarAudienciaForm">
                    <input type="hidden" name="audienciaId" id="audienciaId" value="${audiencia.id}"/>
                    <div class="row">
                        <div class="form-group">
                            <div class="col-md-12">
                                <label>Acciones *</label>
                                <div class="input-group">
                                    <textarea rows="4" cols="80" style="width: 350px;" id="accionesAudiencia" name='accionesAudiencia' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" >${audiencia.acciones}</textarea> 
                                </div>  
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group">
                            <div class="col-md-12">
                                <label>Resultado *</label>
                                <div class="input-group">
                                    <textarea rows="4" cols="80" style="width: 350px;" id="resultadoAudiencia" name='resultadoAudiencia' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase">${audiencia.resultado}</textarea> 
                                </div>  
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group">
                            <div class="col-md-12">
                                <div class="checkbox checkbox-info checkbox-circle">
                                    <input id="checkbox8" type="checkbox" name="diferirAudiencia" id="diferirAudiencia" onchange="mostrarOcultarMotivo();">
                                    <label for="checkbox8">
                                        <strong>Diferir</strong>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="reprogramacion" style="display: none;">
                        <div id="motivoReprogramacion" class="row" >
                            <div class="form-group">
                                <div class="col-md-12">
                                    <label>Motivo de Reprogramación *</label>
                                    <div class="input-group">
                                        <textarea rows="4" cols="80" style="width: 350px;" id="motivo" name='motivo' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"></textarea> 
                                    </div>  
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group" id="data_1">
                                    <label>Nueva Fecha de Audiencia *</label>
                                    <div class="input-group date datepicker">
                                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input style="width: 255px;text-align: center;" readOnly name="fechaAud" id="fechaAud" type="text" class="form-control" value="${formatDate(format:'dd/MM/yyyy',date:audiencia.fechaDeAudiencia)}">
                                    </div>
                                </div>  
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group" id="data_1">
                                    <label>Nueva Hora de Audiencia *</label>
                                    <div class="input-group clockpicker">
                                        <span class="input-group-addon">
                                            <span class="fa fa-clock-o"></span>
                                        </span>
                                        <input type="text" style="width: 255px;text-align: center;"  class="form-control"  name="hora" id="hora" readOnly>
                                    </div>
                                </div>  
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label>Asistente *</label>
                                    <div class="input-group">
                                        <input id="nombreAsistente" name="nombreAsistente" maxlength="80" required style="width: 300px; text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${audiencia.asistente}">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <g:submitToRemote onSuccess="mostrarAudiencia(data);ocultarModal('modalDetalleAudiencia');" onFailure="alert('algo fallo');" onComplete="" class="btn btn-primary" url="[controller: 'audienciaJuicio',action: 'update']" method="POST" value="Actualizar"/>
                            </div>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>
        <div id="btnDetalles" class="row">
            <div class="col-md-12">
                <div class="form-group">
                    <g:link controller='juicio' action='show' id='${juicio.id}' class="btn btn-success btn-bitbucket"><i class="fa fa-legal"></i>&nbsp;&nbsp;<span class="bold">Ir al Juicio</span></g:link>
                    <g:if test="${audiencia.cancelada == false && audiencia.juicio.estadoDeJuicio.id == 1}">
                        <button type="button"  class="btn btn-primary" onclick="editarAudiencia();"><i class="fa fa-edit"></i>&nbsp;&nbsp;<span class="bold">Editar Audiencia</span></button>
                    </g:if>
                </div>
            </div>
        </div>
    </div>
</g:if>