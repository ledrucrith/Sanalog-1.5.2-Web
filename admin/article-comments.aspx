﻿<%@ Page Title="" Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true"
    CodeFile="article-comments.aspx.cs" Inherits="admin_makyorum" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('body').on("click", ".icon_sil", function () {
                if ($('input[rel=Sec]:checked').length < 1) {
                    bootbox.alert('Herhangi bir seçim yapmadınız.');
                    return;
                }

                bootbox.confirm("Silmek istediğinizden emin misiniz?", function (result) {
                    if (result != true)
                        return;

                    $('[name=HdnSil]').val('');
                    $('input[rel=Sec]:checked').each(function () {
                        $('[name=HdnSil]').val($('[name=HdnSil]').val() + $(this).val() + ',');
                    });
                    $('[name=HdnSil]').val($('[name=HdnSil]').val().substring(0, $('[name=HdnSil]').val().length - 1));
                    $('form').submit();
                });
            });

            $('body').on("click", ".icon_vazgec", function () {
                $find('<%= MPE1.ClientID %>').hide();
            });

            $('body').on("change", "input[rel=TSec]", function () {
                $("input[rel=Sec]").prop('checked', $(this).is(':checked'));
            });

            $('textarea[limit]').keyup(function (e) {
                var limit = $(this).attr('limit');
                if ($(this).val().length >= limit) {
                    if (e.keyCode != 8 && e.keyCode != 46)
                        e.preventDefault();
                    $(this).val($(this).val().substring(0, limit));
                }
                $('#' + $(this).attr('span')).text(limit - $(this).val().length);
            }).keydown(function (e) {
                var limit = $(this).attr('limit');
                if ($(this).val().length >= limit) {
                    if (e.keyCode != 8 && e.keyCode != 46)
                        e.preventDefault();
                    $(this).val($(this).val().substring(0, limit));
                }
                $('#' + $(this).attr('span')).text(limit - $(this).val().length);
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" runat="Server">
    <cc1:ToolkitScriptManager runat="server"></cc1:ToolkitScriptManager>
    <div class="row makaleYorum">
        <div class="col-md-12">

            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="page-head-x4"><%= Resources.admin_language.article_comment %></div>
                    <div class="page-head-x1"><%= Resources.admin_language.article_comment_help %></div>


                    <div class="row mb-md buttons" data-spy="affix" data-offset-top="150">
                        <div class="col-md-12">
                            <a href="javascript:;" class="btn btn-danger icon_sil"><%= Resources.admin_language.delete %></a>

                        </div>
                    </div>

                    <div id="global_errors" class="errors-out">
                        <div class="errors-in">
                        </div>
                    </div>

                    <div class="panel">
                        <div class="panel-heading"><%= Resources.admin_language.article_comment %> </div>
                        <div class="panel-body">
                            <p class="pageSelect mb-lg">
                                <asp:DropDownList ID="DDLOnay" CssClass="form-control" runat="server" AutoPostBack="True">
                                    <asp:ListItem Value="False" Text="<%$ Resources:admin_language, article_comment_waiting %>"></asp:ListItem>
                                    <asp:ListItem Value="True" Text="<%$ Resources:admin_language, article_comment_succes %>"></asp:ListItem>
                                </asp:DropDownList>
                            </p>

                            <input type="hidden" name="HdnSil" />
                            <asp:GridView ID="GVYorumlar" class="table table-bordered table-striped tbl" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                DataKeyNames="YId" DataSourceID="SDSYorumlar" OnSelectedIndexChanged="GVYorumlar_SelectedIndexChanged"
                                OnDataBound="GVYorumlar_DataBound">
                                <Columns>
                                    <asp:TemplateField ItemStyle-CssClass="secim" HeaderStyle-CssClass="secim">
                                        <HeaderTemplate>
                                            <input rel="TSec" type="checkbox" title="Tümünü seç" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input rel="Sec" type="checkbox" value="<%# Eval("YId") %>" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:admin_language,article_header %>" ItemStyle-CssClass="baslik">
                                        <ItemTemplate>
                                            <asp:LinkButton runat="server" CommandName="Select" Text='<%# Eval("Baslik") %>'></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <PagerTemplate>
                                    <nav>
                                <ul class="pagination" >
                                    <li><asp:LinkButton runat="server" ID="IlkPage" CommandName="First" aria-hidden="true" >&laquo;</asp:LinkButton></li>
                                    <li><asp:LinkButton runat="server" ID="geri" CommandName="Prev"   aria-hidden="true" >&#8249;</asp:LinkButton> </li>
                                    <asp:PlaceHolder ID="Sayfalama" runat="server" />
                                    <li><asp:LinkButton runat="server" ID="ileri"  CommandName="Next" aria-hidden="true" >&#8250;</asp:LinkButton></li>
                                    <li><asp:LinkButton runat="server" ID="SonPage" CommandName="Last"   aria-hidden="true" >&raquo;</asp:LinkButton></li>
                                </ul>
                            </nav>
                                </PagerTemplate>
                                <RowStyle CssClass="satir" />
                                <AlternatingRowStyle CssClass="aSatir" />

                                <HeaderStyle CssClass="baslikSatir" />
                            </asp:GridView>

                        </div>
                    </div>


                </ContentTemplate>
            </asp:UpdatePanel>


            <asp:Label ID="gizli" runat="server" />
            <cc1:ModalPopupExtender ID="MPE1" runat="server" TargetControlID="gizli" PopupControlID="popup"
                BackgroundCssClass="popup">
            </cc1:ModalPopupExtender>
            <div id="popup" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
                <div class="modal-dialog modal-lg" role="document">
                    <div id="content" class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close icon_vazgec" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="myModalLabel"><%= Resources.admin_language.article_comment_comm %></h4>
                        </div>
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>
                                <asp:FormView ID="FVYorum" runat="server" DataKeyNames="YId" DataSourceID="SDSYorum"
                                    DefaultMode="Edit">
                                    <EditItemTemplate>


                                        <div class="modal-body">

                                            <div class="row form-group no-gutter">
                                                <label class="col-md-4"><%= Resources.admin_language.article %></label>
                                                <div class="col-md-8">
                                                    <%# Eval("Baslik") %>
                                                </div>
                                            </div>

                                            <div class="row form-group no-gutter">
                                                <label class="col-md-4"><%= Resources.admin_language.article_comment_confirmation %></label>
                                                <div class="col-md-8">
                                                    <asp:CheckBox ID="CB" runat="server" Checked='<%# Bind("Onay") %>' />
                                                </div>
                                            </div>

                                            <div class="row form-group no-gutter">
                                                <label class="col-md-4"><%= Resources.admin_language.article_comment_writer %></label>
                                                <div class="col-md-8">
                                                    <asp:TextBox ID="TB" CssClass="form-control" runat="server" Text='<%# Bind("Yazan") %>' MaxLength="30" Enabled='<%# string.IsNullOrEmpty(Eval("UyeId").ToString()) %>' />
                                                </div>
                                            </div>
                                            <div class="row form-group no-gutter">
                                                <label class="col-md-4"><%= Resources.admin_language.mail %></label>
                                                <div class="col-md-8">
                                                    <asp:TextBox ID="TB2" CssClass="form-control" runat="server" Text='<%# Bind("EPosta") %>' MaxLength="150" Enabled='<%# string.IsNullOrEmpty(Eval("UyeId").ToString()) %>' />
                                                </div>
                                            </div>

                                            <div class="row form-group no-gutter">
                                                <label class="col-md-4"><%= Resources.admin_language.article_comment %></label>
                                                <div class="col-md-8">
                                                    <asp:TextBox ID="TB1" CssClass="form-control" runat="server" Text='<%# Bind("Yorum") %>' Height="90px" TextMode="MultiLine"
                                                        limit="10000" span="TBilgiSay" />
                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="TB1" CssClass="hata"
                                                        Display="Dynamic" ErrorMessage="*" ValidationGroup="yorum" SetFocusOnError="true"></asp:RequiredFieldValidator>
                                                    <br />
                                                    <span class="spanlimit" id="TBilgiSay"></span>
                                                </div>
                                            </div>
                                            <div class="row form-group no-gutter">
                                                <label class="col-md-4"><%= Resources.admin_language.article_comment_mail %></label>
                                                <div class="col-md-8">
                                                    <asp:CheckBox ID="CBMail" runat="server" />
                                                </div>
                                            </div>


                                        </div>
                                        <div class="modal-footer">
                                            <asp:LinkButton runat="server" class="btn btn-info icon_kaydet" ValidationGroup="yorum" CommandName="Update"> <%= Resources.admin_language.save %></asp:LinkButton>
                                        </div>

                                    </EditItemTemplate>
                                </asp:FormView>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>

            </div>

        </div>
    </div>


    <asp:SqlDataSource ID="SDSYorum" runat="server" ConnectionString="<%$ ConnectionStrings:e_cobiConn %>"
        SelectCommand="snlg_V1.msp_MakaleYorumDetay" SelectCommandType="StoredProcedure"
        UpdateCommand="snlg_V1.msp_MakaleYorumGuncelle" UpdateCommandType="StoredProcedure"
        OnUpdated="SDSYorum_Updated" OnUpdating="SDSYorum_Updating">
        <SelectParameters>
            <asp:ControlParameter ControlID="GVYorumlar" Name="YId" PropertyName="SelectedValue"
                Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="YId" Type="Int32" />
            <asp:Parameter Name="Onay" Type="Boolean" />
            <asp:Parameter Name="Yorum" Type="String" />
            <asp:Parameter Name="Yazan" Type="String" />
            <asp:Parameter Name="EPosta" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SDSYorumlar" runat="server" ConnectionString="<%$ ConnectionStrings:e_cobiConn%>"
        SelectCommand="snlg_V1.msp_MakaleYorumlar" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter ControlID="DDLOnay" Name="Onay" PropertyName="SelectedValue"
                Type="Boolean" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
