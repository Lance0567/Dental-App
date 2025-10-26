unit uUsers;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid,
  FMX.Objects, FMX.Skia, FMX.ImgList, FMX.Controls.Presentation, FMX.Edit,
  FMX.Layouts, Data.DB, Data.Bind.EngExt, FMX.Bind.DBEngExt, FMX.Bind.Grid,
  System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.Components,
  System.Threading, Data.Bind.Grid, Data.Bind.DBScope, FireDAC.Stan.Param, uToolbar,
  FMX.Effects;

type
  TfUsers = class(TFrame)
    ScrollBox1: TScrollBox;
    lytBottom: TLayout;
    lytComponents: TLayout;
    lytSearch: TLayout;
    eSearch: TEdit;
    lytButtonH: TLayout;
    btnAddNewUser: TCornerButton;
    lytHeader: TLayout;
    lytTitle: TLayout;
    lbTitle: TLabel;
    lbDescription: TLabel;
    rUsers: TRectangle;
    gUsers: TGrid;
    bsdbUsers: TBindSourceDB;
    blUsers: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    fToolbar: TfToolbar;
    ShadowEffect1: TShadowEffect;
    procedure btnAddNewUserClick(Sender: TObject);
    procedure gUsersCellDblClick(const Column: TColumn; const Row: Integer);
    procedure eSearchChangeTracking(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure FrameResized(Sender: TObject);
    procedure gUsersResized(Sender: TObject);
  private
    procedure GridContentsResponsive2;
    procedure GridContentsResponsive3;
    { Private declarations }
  public
    procedure GridContentsResponsive;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uMain, uDm;

{ Grid column resize }
procedure TfUsers.GridContentsResponsive;
var
  i: Integer;
  NewWidth: Single;
  FixedWidth: Single;
  FixedColumns: Integer;
begin
  if gUsers.ColumnCount = 0 then
    Exit;

  if frmMain.ClientWidth <= 850 then
  begin
    // Fixed layout at 850px
    for i := 0 to gUsers.ColumnCount - 1 do
    begin
      if (i = 0) or (i = 1) or (i = 3) or (i = 4) or (i = 5) then
        gUsers.Columns[i].Width := 130
      else
        gUsers.Columns[i].Width := 220;
    end;
  end
  else if frmMain.ClientWidth > 850 then
  begin
    // Dynamic layout when wider than 850px
    FixedWidth := 130; // width for 3rd and last columns
    FixedColumns := 5; // 5 fixed columns

    if gUsers.ColumnCount > FixedColumns then
      NewWidth := (gUsers.Width - (FixedWidth * FixedColumns)) /
        (gUsers.ColumnCount - FixedColumns)
    else
      NewWidth := gUsers.Width / gUsers.ColumnCount;

    for i := 0 to gUsers.ColumnCount - 1 do
    begin
      if (i = 0) or (i = 1) or (i = 3) or (i = 4) or (i = 5) then
        gUsers.Columns[i].Width := FixedWidth - 1
      else
        gUsers.Columns[i].Width := NewWidth - 2;
    end;
  end;
end;

{ Grid column resize with 2ms delay }
procedure TfUsers.GridContentsResponsive2;
begin
  TTask.Run(
    procedure
    begin
      Sleep(200); // wait 200ms

      TThread.Synchronize(nil,
        procedure
        var
          i: Integer;
          NewWidth: Single;
          FixedWidth: Single;
          FixedColumns: Integer;
        begin
          if gUsers.ColumnCount = 0 then
            Exit;

          if frmMain.ClientWidth <= 850 then
          begin
            // Fixed layout for 850px
            for i := 0 to gUsers.ColumnCount - 1 do
            begin
              if (i = 0) or (i = 1) or (i = 3) or (i = 4) or (i = 5) then
                gUsers.Columns[i].Width := 130
              else
                gUsers.Columns[i].Width := 220;
            end;
          end
          else if frmMain.ClientWidth > 850 then
          begin
            // Dynamic layout
            FixedWidth := 130; // Width for 3rd and last columns
            FixedColumns := 5;

            if gUsers.ColumnCount > FixedColumns then
              NewWidth := (gUsers.Width - (FixedWidth * FixedColumns)) /
                (gUsers.ColumnCount - FixedColumns)
            else
              NewWidth := gUsers.Width / gUsers.ColumnCount;

            for i := 0 to gUsers.ColumnCount - 1 do
            begin
              if (i = 0) or (i = 1) or (i = 3) or (i = 4) or (i = 5) then
                gUsers.Columns[i].Width := FixedWidth - 1
              else
                gUsers.Columns[i].Width := NewWidth - 2;
            end;
          end;
        end);
    end);
end;

{ Grid column resize with 8ms delay }
procedure TfUsers.GridContentsResponsive3;
begin
  TTask.Run(
    procedure
    begin
      Sleep(800); // wait 800ms

      TThread.Synchronize(nil,
        procedure
        var
          i: Integer;
          NewWidth: Single;
          FixedWidth: Single;
          FixedColumns: Integer;
        begin
          if gUsers.ColumnCount = 0 then
            Exit;

          if frmMain.ClientWidth <= 850 then
          begin
            // Fixed layout for 850px
            for i := 0 to gUsers.ColumnCount - 1 do
            begin
              if (i = 0) or (i = 1) or (i = 3) or (i = 4) or (i = 5) then
                gUsers.Columns[i].Width := 130
              else
                gUsers.Columns[i].Width := 220;
            end;
          end
          else if frmMain.ClientWidth > 850 then
          begin
            // Dynamic layout
            FixedWidth := 130; // Width for 3rd and last columns
            FixedColumns := 5;

            if gUsers.ColumnCount > FixedColumns then
              NewWidth := (gUsers.Width - (FixedWidth * FixedColumns)) /
                (gUsers.ColumnCount - FixedColumns)
            else
              NewWidth := gUsers.Width / gUsers.ColumnCount;

            for i := 0 to gUsers.ColumnCount - 1 do
            begin
              if (i = 0) or (i = 1) or (i = 3) or (i = 4) or (i = 5) then
                gUsers.Columns[i].Width := FixedWidth - 1
              else
                gUsers.Columns[i].Width := NewWidth - 2;
            end;
          end;
        end);
    end);
end;

{ Search user }
procedure TfUsers.eSearchChangeTracking(Sender: TObject);
var
  SearchText: string;
begin
  dm.qUsers.DisableControls;
  try
    dm.qUsers.Close;

    if Trim(eSearch.Text) = '' then
    begin
      // No search: load all records
      dm.qUsers.SQL.Text := 'SELECT * FROM users';
    end
    else
    begin
      // Search with parameter
      dm.qUsers.SQL.Text := 'SELECT * FROM users WHERE name LIKE :search';
      SearchText := '%' + eSearch.Text + '%';
      dm.qUsers.ParamByName('search').AsString := SearchText;
    end;

    dm.qUsers.Open;
  finally
    dm.qUsers.EnableControls;
  end;

  GridContentsResponsive3;
end;

{ Add New User }
procedure TfUsers.btnAddNewUserClick(Sender: TObject);
begin
  // Set record status to Add
  dm.RecordStatus := 'Add';

  // Set title
  frmMain.fUserModal.lbTitle.Text := 'Add New User';

  // Set button text
  frmMain.fUserModal.btnSaveUser.Text := 'Create User';

  // Clear Fields
  frmMain.fUserModal.ClearItems;
  frmMain.fUserModal.lytPassword.Visible := True;
  frmMain.fUserModal.rUser.Height := 660;

  // Reset scrollbox
  frmMain.fUserModal.ScrollBox1.ViewportPosition := PointF(0, 0);

  // User Modal visibility
  frmMain.fUserModal.Visible := True;
  frmMain.fUserModal.gIcon.Visible := True; // Show user icon

  // Profile Icon
  frmMain.fUserModal.gIcon.ImageIndex := 10;
  frmMain.fUserModal.gIcon.Visible := True;
  frmMain.fUserModal.lNameH.Visible := False;

  // Hide validation components
  frmMain.fUserModal.crFullName.Visible := False;
  frmMain.fUserModal.crUsername.Visible := False;
  frmMain.fUserModal.crPassword.Visible := False;
  frmMain.fUserModal.crEmailAddress.Visible := False;
  frmMain.fUserModal.crContactNumber.Visible := False;
  frmMain.fUserModal.crUsername.Visible := False;
end;

{ Edit User record }
procedure TfUsers.gUsersCellDblClick(const Column: TColumn; const Row: Integer);
var
  ms: TMemoryStream;
begin
  frmMain.fUserDetails.Visible := True; // Show patient modal

  // Populate the modal form
  // Get Fullname
  frmMain.fUserDetails.lName.Text := dm.qUsers.FieldByName('name').AsString;

  // Get email address
  frmMain.fUserDetails.slEmail.Words.Items[1].Text := dm.qUsers.FieldByName('email_address').AsString;

  // Get contact number
  frmMain.fUserDetails.slPhone.Words.Items[1].Text := dm.qUsers.FieldByName('contact_number').AsString;

  // Get Profile Photo
  // Load Profile Photo (LONGBLOB -> TImage)
  frmMain.fUserDetails.cProfilePhoto.Fill.Kind := TBrushKind.Bitmap;
  ms := TMemoryStream.Create;
  try
    if not dm.qUsers.FieldByName('profile_pic').IsNull then
    begin
      TBlobField(dm.qUsers.FieldByName('profile_pic')).SaveToStream(ms);
      ms.Position := 0;
      frmMain.fUserDetails.cProfilePhoto.Fill.Bitmap.Bitmap.LoadFromStream(ms);
      frmMain.fUserDetails.lNameH.Visible := False;  // Hide Name holder
      frmMain.fUserDetails.gIcon.ImageIndex := -1;
    end
    else
    begin
      frmMain.fUserDetails.cProfilePhoto.Fill.Bitmap.Bitmap := nil; // Clear if no photo
      frmMain.fUserDetails.cProfilePhoto.Fill.Kind := TBrushKind.Solid;  // Set background
      frmMain.fUserDetails.lNameH.Visible := True;
      frmMain.fUserDetails.gIcon.ImageIndex := -1;
    end;
  finally
    frmMain.fUserDetails.gIcon.ImageIndex := -1; // Hide Icon
    frmMain.fUserDetails.cProfilePhoto.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    ms.Free;
  end;

  // Get user role in the database
  frmMain.fUserDetails.lRole.Text := dm.qUsers.FieldByName('user_role').AsString;
  if frmMain.fUserDetails.lRole.Text = 'Admin' then
  begin
    frmMain.fUserDetails.rRoleH.Fill.Color := $FEF3E8FF;
    frmMain.fUserDetails.rRoleH.Width := 90;
    frmMain.fUserDetails.lRole.TextSettings.FontColor := $FE6B21A8;
  end
  else
  begin
    frmMain.fUserDetails.rRoleH.Fill.Color := $FEDBEAFE;
    frmMain.fUserDetails.rRoleH.Width := 125;
    frmMain.fUserDetails.lRole.TextSettings.FontColor := $FE1E40AF;
  end;

  // Get Department
  frmMain.fUserDetails.slDepartment.Words.Items[1].Text := dm.qUsers.FieldByName('department').AsString;

  // Get status in the database
  frmMain.fUserDetails.lStatus.Text := dm.qUsers.FieldByName('status').AsString;
  if frmMain.fUserDetails.lStatus.Text = 'Active' then
  begin
    frmMain.fUserDetails.rStatusH.Fill.Color := $FEDCFCE7;
    frmMain.fUserDetails.rStatusH.Width := 70;
    frmMain.fUserDetails.lStatus.TextSettings.FontColor := $FE166534;
  end
  else
  begin
    frmMain.fUserDetails.rStatusH.Fill.Color := $FEFEE2E2;
    frmMain.fUserDetails.rStatusH.Width := 90;
    frmMain.fUserDetails.lStatus.TextSettings.FontColor := $FE991B1B;
  end;

  // Get Hire date
  frmMain.fUserDetails.slHireDate.Words.Items[1].Text := dm.qUsers.FieldByName('date_created').AsString;

  // Get last login
  frmMain.fUserDetails.slLastLogin.Words.Items[1].Text := dm.qUsers.FieldByName('last_login').AsString;
  frmMain.fUserDetails.ClearItems;  // Clear items
end;

{ Grid Resized }
procedure TfUsers.gUsersResized(Sender: TObject);
begin
  GridContentsResponsive2;
end;

{ Frame Resize }
procedure TfUsers.FrameResize(Sender: TObject);
begin
  GridContentsResponsive2;
end;

{ Frame Resized }
procedure TfUsers.FrameResized(Sender: TObject);
begin

  GridContentsResponsive2;
end;

end.
