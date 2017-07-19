<g:if test="${datosAdicionales}">
    <div class="row" style="background-color: #ffffff;">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr style="background-color: #e31937; color: white; font-weight: bold; padding: 20px 30px; font-variant: small-caps;">
                                    <th style="text-align:center;">Expediente Interno</th>
                                    <th style="text-align:center;">Expediente de Juicio</th>
                                    <th style="text-align:center;">Tipo de Juicio</th>
                                    <th style="text-align:center;">Etapa</th>
                                    <th style="text-align:center;">Pregunta</th>
                                    <th style="text-align:center;">Respuesta</th>
                                    <th style="text-align:center;">Usuario que Respondió</th>
                                    <th style="text-align:center;">Fecha de Respuesta</th>
                                    <th style="text-align:center;">Usuario que modificó</th>
                                    <th style="text-align:center;">Fecha de modificación</th>
                                </tr>
                            </thead>
                            <tbody style="font-size: 12px;">
                                <g:each var='migracion' in='${datosAdicionales}'>
                                    <tr>
                                        <td style="border-bottom: solid 1px #b3b3b3; padding-top: 5px; padding-bottom: 5px;">${migracion.expInterno}</td>
                                        <td style="border-bottom: solid 1px #b3b3b3; padding-top: 5px; padding-bottom: 5px;">${migracion.expJuicio}</td>
                                        <td style="border-bottom: solid 1px #b3b3b3; padding-top: 5px; padding-bottom: 5px;">${migracion.tipoJuicio}</td>
                                        <td style="border-bottom: solid 1px #b3b3b3; padding-top: 5px; padding-bottom: 5px;">${migracion.cofaNombre}</td>
                                        <td style="border-bottom: solid 1px #b3b3b3; padding-top: 5px; padding-bottom: 5px;">${migracion.coflTitulo}</td>
                                        <td style="border-bottom: solid 1px #b3b3b3; padding-top: 5px; padding-bottom: 5px;">${migracion.respuesta}</td>
                                        <td style="border-bottom: solid 1px #b3b3b3; padding-top: 5px; padding-bottom: 5px;">${migracion.usuarioAlta}</td>
                                        <td style="border-bottom: solid 1px #b3b3b3; padding-top: 5px; padding-bottom: 5px;">${migracion.fechaAlta}</td>
                                        <td style="border-bottom: solid 1px #b3b3b3; padding-top: 5px; padding-bottom: 5px;">${migracion.usuarioCambio}</td>
                                        <td style="border-bottom: solid 1px #b3b3b3; padding-top: 5px; padding-bottom: 5px;">${migracion.fechaCambio}</td>
                                    </tr>
                                </g:each>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</g:if>
<g:else>
    <div class="row text-center"><p>No hay datos migrados para este Juicio.</p></div>
</g:else>