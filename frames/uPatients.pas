unit uPatients;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Skia, FMX.Objects, FMX.Skia,
  FMX.ImgList, FMX.Edit, System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, System.Threading,
  Data.DB, FireDAC.Stan.Param, FMX.Ani, FMX.MultiView, uToolbar, FMX.Effects;

type
  TfPatients = class(TFrame)
    lytHeader: TLayout;
    lytTitle: TLayout;
    lbTitle: TLabel;
    lbDescription: TLabel;
    lytComponents: TLayout;
    eSearch: TEdit;
    lytSearch: TLayout;
    lytButtonH: TLayout;
    btnAddNewPatient: TCornerButton;
    gPatients: TGrid;
    ScrollBox1: TScrollBox;
    rPatients: TRectangle;
    bsdbPatients: TBindSourceDB;
    blPatients: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    fToolbar: TfToolbar;
    lytBottom: TLayout;
    ShadowEffect1: TShadowEffect;
    procedure gPatientsCellDblClick(const Column: TColumn; const Row: Integer);
    procedure FrameResized(Sender: TObject);
    procedure btnAddNewPatientClick(Sender: TObject);
    procedure eSearchChangeTracking(Sender: TObject);
    procedure gPatientsResized(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    procedure GridContentsResponsive3;
    { Private declarations }
  public
    procedure GridContentsResponsive;
    procedure GridContentsResponsive2;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uPatientModal, uMain, uDashboard, uDm;

{ Grid column resize }
procedure TfPatients.GridContentsResponsive;
var
  i: Integer;
  NewWidth: Single;
  FixedWidth: Single;
  FixedColumns: Integer;
begin
  if gPatients.ColumnCount = 0 then Exit;

  if frmMain.ClientWidth <= 850 then
  begin
    // Fixed layout at 850px
    for i := 0 to gPatients.ColumnCount - 1 do
    begin
      if (i = 0) or (i = 2) or (i = 3) or (i = 4) then
        gPatients.Columns[i].Width := 130
      else
        gPatients.Columns[i].Width := 220;
    end;
  end
  else if frmMain.ClientWidth > 850 then
  begin
    // Dynamic layout when wider than 850px
    FixedWidth := 130;      // width for 2nd and last columns
    FixedColumns := 4;      // 2 fixed columns

    if gPatients.ColumnCount > FixedColumns then
      NewWidth := (gPatients.Width - (FixedWidth * FixedColumns)) / (gPatients.ColumnCount - FixedColumns)
    else
      NewWidth := gPatients.Width / gPatients.ColumnCount;

    for i := 0 to gPatients.ColumnCount - 1 do
    begin
      if (i = 0) or (i = 2) or (i = 3) or (i = 4) then
        gPatients.Columns[i].Width := FixedWidth - 1
      else
        gPatients.Columns[i].Width := NewWidth - 2;
    end;
  end;
end;

{ Grid column resize with 2ms delay }
procedure TfPatients.GridContentsResponsive2;
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
          if gPatients.ColumnCount = 0 then Exit;

          if frmMain.ClientWidth <= 850 then
          begin
            // Fixed layout for 850px
            for i := 0 to gPatients.ColumnCount - 1 do
            begin
              if (i = 0) or (i = 2) or (i = 3) or (i = 4) then
                gPatients.Columns[i].Width := 130
              else
                gPatients.Columns[i].Width := 220;
            end;
          end
          else if frmMain.ClientWidth > 850 then
          begin
            // Dynamic layout
            FixedWidth := 130; // Width for 2nd and last columns
            FixedColumns := 4;

            if gPatients.ColumnCount > FixedColumns then
              NewWidth := (gPatients.Width - (FixedWidth * FixedColumns)) / (gPatients.ColumnCount - FixedColumns)
            else
              NewWidth := gPatients.Width / gPatients.ColumnCount;

            for i := 0 to gPatients.ColumnCount - 1 do
            begin
              if (i = 0) or (i = 2) or (i = 3) or (i = 4) then
                gPatients.Columns[i].Width := FixedWidth - 1
              else
                gPatients.Columns[i].Width := NewWidth - 2;
            end;
          end;
        end
      );
    end
  );
end;

{ Grid column resize with 8ms delay }
procedure TfPatients.GridContentsResponsive3;
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
          if gPatients.ColumnCount = 0 then Exit;

          if frmMain.ClientWidth <= 850 then
          begin
            // Fixed layout for 850px
            for i := 0 to gPatients.ColumnCount - 1 do
            begin
              if (i = 0) or (i = 2) or (i = 3) or (i = 4) then
                gPatients.Columns[i].Width := 130
              else
                gPatients.Columns[i].Width := 220;
            end;
          end
          else if frmMain.ClientWidth > 850 then
          begin
            // Dynamic layout
            FixedWidth := 130; // Width for 2nd and last columns
            FixedColumns := 4;

            if gPatients.ColumnCount > FixedColumns then
              NewWidth := (gPatients.Width - (FixedWidth * FixedColumns)) / (gPatients.ColumnCount - FixedColumns)
            else
              NewWidth := gPatients.Width / gPatients.ColumnCount;

            for i := 0 to gPatients.ColumnCount - 1 do
            begin
              if (i = 0) or (i = 2) or (i = 3) or (i = 4) then
                gPatients.Columns[i].Width := FixedWidth - 1
              else
                gPatients.Columns[i].Width := NewWidth - 2;
            end;
          end;
        end
      );
    end
  );
end;

{ Add New Patient }
procedure TfPatients.btnAddNewPatientClick(Sender: TObject);
begin
  // Set the record status to Add
  dm.RecordStatus := 'Add';

  // Set title
  frmMain.fPatientModal.lbTitle.Text := 'Add New Patient';

  // Set button text
  frmMain.fPatientModal.btnSavePatient.Text := 'Save Patient';

  // Reset tracking
  frmMain.fPatientModal.MemoTrackingReset := '';

  // Clear Fields
  frmMain.fPatientModal.ClearItems;
  frmMain.fPatientModal.btnDelete.Visible := False;

  // Reset scrollbox
  frmMain.fPatientModal.ScrollBox1.ViewportPosition := PointF(0, 0);

  // Patient Modal visibility
  frmMain.fPatientModal.Visible := True;

  // Profile Icon
  frmMain.fPatientModal.gIcon.ImageIndex := 10;
  frmMain.fPatientModal.gIcon.Visible := True;
  frmMain.fPatientModal.lNameH.Visible := False;

  // Hide validation components
  frmMain.fPatientModal.crFullName.Visible := False;
  frmMain.fPatientModal.crContactNumber.Visible := False;

  // Patient Modal tag
  frmMain.fPatientModal.lTag.Text := 'Tag Number : ' + frmMain.fPatientModal.MemoTrackingReset;
end;

{ Edit Patient record }
procedure TfPatients.gPatientsCellDblClick(const Column: TColumn;
  const Row: Integer);
var
  genderH: String;
  ms: TMemoryStream;
begin
  frmMain.fPatientModal.Visible := True;  // Show patient modal
  frmMain.fPatientModal.ScrollBox1.ViewportPosition := PointF(0, 0);
  dm.RecordStatus := 'Edit'; // Set record Status
  frmMain.fPatientModal.lbTitle.Text := 'Update Existing Patient';
  frmMain.fPatientModal.btnSavePatient.Text := 'Update Patient';
  frmMain.fPatientModal.MemoTrackingReset := '';  // Reset tracking

  // Populate the modal form
  // Get Fullname
  frmMain.fPatientModal.eFullName.Text := dm.qPatients.FieldByName('fullname').AsString;

  // Get gender in the database
  genderH := dm.qPatients.FieldByName('gender').AsString;
  if genderH = 'Male' then
    frmMain.fPatientModal.cbGender.ItemIndex := 0
  else if genderH = 'Female' then
    frmMain.fPatientModal.cbGender.ItemIndex := 1
  else
    frmMain.fPatientModal.cbGender.ItemIndex := 2;

  // Get Profile Photo
  // Load Profile Photo (LONGBLOB -> TImage)
  frmMain.fPatientModal.cProfilePhoto.Fill.Kind := TBrushKind.Bitmap;
  ms := TMemoryStream.Create;
  try
    if not dm.qPatients.FieldByName('profile_photo').IsNull then
    begin
      TBlobField(dm.qPatients.FieldByName('profile_photo')).SaveToStream(ms);
      ms.Position := 0;
      frmMain.fPatientModal.cProfilePhoto.Fill.Bitmap.Bitmap.LoadFromStream(ms);
      frmMain.fPatientModal.lNameH.Visible := False;  // Hide Name holder
    end
    else
    begin
      frmMain.fPatientModal.cProfilePhoto.Fill.Bitmap.Bitmap := nil; // Clear if no photo
      frmMain.fPatientModal.cProfilePhoto.Fill.Kind := TBrushKind.Solid; // Set color background
    end;
  finally
    frmMain.fPatientModal.gIcon.ImageIndex := -1; // Hide Icon
    frmMain.fPatientModal.cProfilePhoto.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    ms.Free;
  end;

  // Get Birth Date
  frmMain.fPatientModal.deDateOfBirth.Date := dm.qPatients.FieldByName('birth_date').AsDateTime;
  frmMain.fPatientModal.deDateOfBirth.TextSettings.FontColor := TAlphaColors.Black; // Show date
  frmMain.fPatientModal.lDateText.Visible := False; // Hide pick label

  // Get Contact Number
  frmMain.fPatientModal.eContactNumber.Text := dm.qPatients.FieldByName('contact_number').AsString;

  // Get Email Address
  frmMain.fPatientModal.eEmailAddress.Text := dm.qPatients.FieldByName('email_address').AsString;

  // Get Address
  frmMain.fPatientModal.eAddress.Text := dm.qPatients.FieldByName('address').AsString;

  // Get Medical Notes
  frmMain.fPatientModal.mMedicalNotes.Text := dm.qPatients.FieldByName('medical_notes').AsString;
end;

{ Patient search procedure }
procedure TfPatients.eSearchChangeTracking(Sender: TObject);
var
  SearchText: string;
begin
  dm.qPatients.DisableControls;
  try
    dm.qPatients.Close;

    if Trim(eSearch.Text) = '' then
    begin
      // No search: load all records
      dm.qPatients.SQL.Text := 'SELECT * FROM patients';
    end
    else
    begin
      // Search with parameter
      dm.qPatients.SQL.Text := 'SELECT * FROM patients WHERE fullname LIKE :search';
      SearchText := '%' + eSearch.Text + '%';
      dm.qPatients.ParamByName('search').AsString := SearchText;
    end;

    dm.qPatients.Open;
  finally
    dm.qPatients.EnableControls;
  end;

  GridContentsResponsive3;
end;

{ Frame Resize }
procedure TfPatients.FrameResize(Sender: TObject);
begin
  GridContentsResponsive2;
end;

{ Frame Resized }
procedure TfPatients.FrameResized(Sender: TObject);
begin
  GridContentsResponsive2;
end;

{ Grid on resize }
procedure TfPatients.gPatientsResized(Sender: TObject);
begin
  GridContentsResponsive2;
end;

end.
