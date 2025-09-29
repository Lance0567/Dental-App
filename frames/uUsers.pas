unit uUsers;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid,
  FMX.Objects, FMX.Skia, FMX.ImgList, FMX.Controls.Presentation, FMX.Edit,
  FMX.Layouts, Data.DB;

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
    rToolbar: TRectangle;
    lBevel: TLine;
    lytToolbarH: TLayout;
    lDate: TLabel;
    gIcon: TGlyph;
    lytUser: TLayout;
    slUserName: TSkLabel;
    rrUserImage: TRoundRect;
    rPatients: TRectangle;
    gUsers: TGrid;
    procedure btnAddNewUserClick(Sender: TObject);
    procedure gUsersCellDblClick(const Column: TColumn; const Row: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uMain, uDm;

{ Add New User }
procedure TfUsers.btnAddNewUserClick(Sender: TObject);
begin
  // Set record status to Add
  frmMain.fUserModal.RecordStatus := 'Add';

  // Set title
  frmMain.fUserModal.lbTitle.Text := 'Add New User';

  // Set button text
  frmMain.fUserModal.btnSaveUser.Text := 'Create User';

  // Clear Fields
  frmMain.fUserModal.ClearItems;

  // Hide Image Frame
  frmMain.fUserModal.rImageFrame.Visible := False;

  // Reset scrollbox
  frmMain.fUserModal.ScrollBox1.ViewportPosition := PointF(0, 0);

  // User Modal visibility
  frmMain.fUserModal.Visible := True;
  frmMain.fUserModal.gIcon.Visible := True;  // Show user icon

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
  roleH: String;
  ms: TMemoryStream;
begin
  frmMain.fUserModal.Visible := True;  // Show patient modal
  frmMain.fUserModal.RecordStatus := 'Edit'; // Set record Status
  frmMain.fUserModal.lbTitle.Text := 'Update Existing Patient'; // Set title
  frmMain.fUserModal.btnSaveUser.Text := 'Update Patient';  // set text in the button

  // Populate the modal form
  // Get Fullname
  frmMain.fUserModal.eFullName.Text := dm.qUsers.FieldByName('name').AsString;

  // Get username
  frmMain.fUserModal.eUsername.Text := dm.qUsers.FieldByName('username').AsString;

  // Get password

  // Get email address
  frmMain.fUserModal.eEmailAddress.Text := dm.qUsers.FieldByName('email_address').AsString;

  // Get contact number
  frmMain.fUserModal.eContactNumber.Text := dm.qUsers.FieldByName('contact_number').AsString;

  // Get Profile Photo
  // Load Profile Photo (LONGBLOB -> TImage)
  ms := TMemoryStream.Create;
  try
    if not dm.qUsers.FieldByName('profile_pic').IsNull then
    begin
      TBlobField(dm.qUsers.FieldByName('profile_pic')).SaveToStream(ms);
      ms.Position := 0;
      frmMain.fUserModal.imgProfilePhoto.Bitmap.LoadFromStream(ms);

      // Image Frame
      frmMain.fUserModal.rImageFrame.Visible := True;
    end
    else
    begin
      frmMain.fUserModal.imgProfilePhoto.Bitmap := nil; // Clear if no photo

      // Image Frame
      frmMain.fUserModal.rImageFrame.Visible := False;
    end;
  finally
    ms.Free;
  end;

  // Get user role in the database
  roleH := dm.qUsers.FieldByName('role').AsString;
  if roleH = 'Admin' then
    frmMain.fUserModal.cbRole.ItemIndex := 0
  else
    frmMain.fUserModal.cbRole.ItemIndex := 1;

  // Get Department
  frmMain.fUserModal.eDepartment.Text := dm.qUsers.FieldByName('department').AsString;

  // Get user role in the database
  roleH := dm.qUsers.FieldByName('role').AsString;
  if roleH = 'Active' then
    frmMain.fUserModal.cbStatus.ItemIndex := 0
  else
    frmMain.fUserModal.cbStatus.ItemIndex := 1;
end;

end.
