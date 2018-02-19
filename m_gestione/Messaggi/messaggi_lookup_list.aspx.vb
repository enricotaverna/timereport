
Partial Class m_gestione_messaggi_list
    Inherits System.Web.UI.Page

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("messaggi_lookup_form.aspx?MessaggioID=" & GridView1.SelectedValue)
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        '	Authorization level 4 needed for this function
        Auth.CheckPermission("CONFIG", "TABLE")
    End Sub
End Class
