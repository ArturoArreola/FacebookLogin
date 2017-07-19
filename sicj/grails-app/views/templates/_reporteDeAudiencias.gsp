<g:if test="${datos}">
    <div class="row" id="contenidoReporteAudiencias" style="background-color: #ffffff;">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="row" style="display: flex; align-items: center; justify-content: center; flex-direction: row;">
                        <div class="col-lg-4 text-center"><img src="/sicj/assets/infonavit.png" width="25%" height="25%"></div>
                        <div class="col-lg-4 text-center">REPORTE DE AUDIENCIAS<br/><p id="tituloDelMes"></p></div>
                        <div class="col-lg-4 text-center">Reporte generado el:<br/><strong><g:formatDate format="dd/MM/yyyy HH:mm" date="${new Date()}"/></strong></div>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr style="background-color: #e31937; color: white; font-weight: bold; padding: 20px 30px; font-variant: small-caps;">
                                    <th>Día</th>
                                    <th>Mes</th>
                                    <th>Hora</th>
                                    <th>Juzgado</th>
                                    <th>Expediente</th>
                                    <th>Quejoso</th>
                                    <th>Audiencia</th>
                                    <th>Acto reclamado</th>
                                    <th>Litigante</th>
                                    <th>Despacho</th>
                                    <th>Resultado</th>
                                    <th>Estatus</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% def fmtDay = new java.text.SimpleDateFormat("EEEE dd", new Locale("es","MX"))
    def fmtMonth = new java.text.SimpleDateFormat("MMMM", new Locale("es","MX"))
    def fmtTime = new java.text.SimpleDateFormat("hh:mm aaa", new Locale("es","MX"))
%>
                                <g:each var='registro' in='${datos}'>
                                    <tr>
                                        <td>${fmtDay.format(registro.audiencia.fechaDeAudiencia)?.toUpperCase()}</td>
                                        <td>${fmtMonth.format(registro.audiencia.fechaDeAudiencia)?.toUpperCase()}</td>
                                        <td>${fmtTime.format(registro.audiencia.fechaDeAudiencia)}</td>
                                        <td>${registro.audiencia.juicio.autoridad ?: registro.audiencia.juzgadoAsignado}</td>
                                        <td>${registro.audiencia.juicio.expediente}</td>
                                        <td>${registro.partes.join(', ')}</td>
                                        <td>${registro.audiencia.tipoDeAudiencia}</td>
                                        <td>${registro.prestacionReclamada?.getAt(0)}</td>
                                        <td>${registro.audiencia.asistente}</td>
                                        <td>${registro.audiencia.juicio.despacho}</td>
                                        <td>${registro.audiencia.resultado}</td>
                                        <td>${registro.audiencia.juicio.estadoDeJuicio}</td>
                                    </tr>
                                </g:each>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row text-center">
        <div class="col-md-12">
            <div class="form-group">
                <button type="button" class="btn btn-success" onclick="exportarReporteAudiencias();"><i class="fa fa-print"></i> Imprimir Audiencias</button>
            </div>
        </div>
    </div>
</g:if>
<g:else>
    <div class="row text-center"><p>No hay audiencias registradas en este periodo.</p></div>
</g:else>