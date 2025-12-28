unit uPatientModal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ImgList, FMX.Controls.Presentation,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  FMX.DateTimeCtrls, FMX.Edit, FMX.ListBox, Data.DB, FMX.Media,
  FMX.MediaLibrary, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, FMX.DialogService, System.DateUtils, FMX.Effects;

type
  TfPatientModal = class(TFrame)
    rBackground: TRectangle;
    rModalInfo: TRectangle;
    lytContentH: TLayout;
    ScrollBox1: TScrollBox;
    lytButtonSaveH: TLayout;
    btnSavePatient: TCornerButton;
    lytMedicalNotes: TLayout;
    lbMedicalNotes: TLabel;
    mMedicalNotes: TMemo;
    lytPatientH: TLayout;
    lytPatientProfile: TLayout;
    cProfilePhoto: TCircle;
    gIcon: TGlyph;
    lNameH: TLabel;
    lbProfilePhoto: TLabel;
    btnUpload: TCornerButton;
    lytPatientDetails: TLayout;
    lytDetails1: TLayout;
    lytFullName: TLayout;
    lbFullName: TLabel;
    eFullName: TEdit;
    lytDateOfBirth: TLayout;
    lbDateOfBirth: TLabel;
    deDateOfBirth: TDateEdit;
    lAgeCounter: TLabel;
    lytDetails2: TLayout;
    lytGender: TLayout;
    lbGender: TLabel;
    cbGender: TComboBox;
    lytContactNumber: TLayout;
    lbContactNumber: TLabel;
    eContactNumber: TEdit;
    lytDetails3: TLayout;
    lytEmailAddress: TLayout;
    lbEmailAddress: TLabel;
    eEmailAddress: TEdit;
    lytAddress: TLayout;
    lbAddress: TLabel;
    eAddress: TEdit;
    lytTitle: TLayout;
    lbTitle: TLabel;
    btnClose: TSpeedButton;
    lTag: TLabel;
    lDateText: TLabel;
    btnCamera: TCornerButton;
    btnCancel: TCornerButton;
    rCameralModal: TRectangle;
    lytImgTools: TLayout;
    lytCameraOption: TLayout;
    lCamera: TLabel;
    cbCameraOption: TComboBox;
    btnSaveCurrentImage: TCornerButton;
    lytClosebtn: TLayout;
    btnCameraClose: TSpeedButton;
    lytPaintBox: TLayout;
    btnTakePicture: TCornerButton;
    ccCapturePhoto: TCameraComponent;
    sdSavePicture: TSaveDialog;
    imgPhoto: TImage;
    crContactNumber: TCalloutRectangle;
    gContactNumber: TGlyph;
    lContactNumberW: TLabel;
    crFullName: TCalloutRectangle;
    gFullName: TGlyph;
    lFullNameW: TLabel;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    lPreviewImage: TLabel;
    GlowEffect1: TGlowEffect;
    PathLabel1: TPathLabel;
    crDateOfBirth: TCalloutRectangle;
    gDateOfBirth: TGlyph;
    lDateOfBirth: TLabel;
    ShadowEffect3: TShadowEffect;
    ShadowEffect4: TShadowEffect;
    ShadowEffect5: TShadowEffect;
    btnDelete: TCornerButton;
    rDeleteBackground: TRectangle;
    rDeleteModal: TRectangle;
    lytDeleteInfo: TLayout;
    lDeleteDesc: TLabel;
    lytDeleteButtonH: TLayout;
    btnDeleteCancel: TCornerButton;
    btnDeletePatient: TCornerButton;
    lytDeleteTitle: TLayout;
    lDeleteTItle: TLabel;
    btnDeleteClose: TSpeedButton;
    procedure mMedicalNotesClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure eFullNameChangeTracking(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure lytDetails1Resize(Sender: TObject);
    procedure lytDetails2Resize(Sender: TObject);
    procedure lytDetails3Resize(Sender: TObject);
    procedure mMedicalNotesExit(Sender: TObject);
    procedure deDateOfBirthChange(Sender: TObject);
    procedure btnSavePatientClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCameraClick(Sender: TObject);
    procedure btnCameraCloseClick(Sender: TObject);
    procedure ccCapturePhotoSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure btnTakePictureClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
    procedure btnSaveCurrentImageClick(Sender: TObject);
    procedure eContactNumberChangeTracking(Sender: TObject);
    procedure eEmailAddressChangeTracking(Sender: TObject);
    procedure eAddressChangeTracking(Sender: TObject);
    procedure deDateOfBirthCheckChanged(Sender: TObject);
    procedure cProfilePhotoClick(Sender: TObject);
    procedure cProfilePhotoPainting(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure btnDeleteCancelClick(Sender: TObject);
    procedure btnDeletePatientClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnDeleteCloseClick(Sender: TObject);
    procedure deDateOfBirthEnter(Sender: TObject);
    procedure deDateOfBirthExit(Sender: TObject);
    procedure deDateOfBirthOpenPicker(Sender: TObject);
    procedure deDateOfBirthClosePicker(Sender: TObject);
  private
    FCapturing: Boolean;
    FStatus: Boolean;
    procedure UpdateCameraList;
    procedure ShowCameraFrame;
    { Private declarations }
  public
    MemoTrackingReset: String;
    procedure EditComponentsResponsive;
    procedure ClearItems;
    { Public declarations }
  end;

  const
  TARGET_WIDTH  = 320;
  TARGET_HEIGHT = 240;

implementation

{$R *.fmx}

uses uMain, uDm;

{ Camera option list }
procedure TfPatientModal.UpdateCameraList;
begin
  cbCameraOption.Clear;
  // FMX currently provides only Default camera selection, but you can fake list
  cbCameraOption.Items.Add('Default Camera');
  cbCameraOption.ItemIndex := 0;
end;

{ Camera live }
procedure TfPatientModal.ShowCameraFrame;
var
  TempBitmap: TBitmap;
begin
  TempBitmap := TBitmap.Create;
  try
    // Get camera frame into a temporary bitmap
    ccCapturePhoto.SampleBufferToBitmap(TempBitmap, True);

    // Resize to 320x240 for consistent appearance
    imgPhoto.Bitmap.SetSize(TARGET_WIDTH, TARGET_HEIGHT);
    imgPhoto.Bitmap.Clear(TAlphaColors.Black); // Optional: background fill
    imgPhoto.Bitmap.Canvas.BeginScene;
    try
      imgPhoto.Bitmap.Canvas.DrawBitmap(
        TempBitmap,
        RectF(0, 0, TempBitmap.Width, TempBitmap.Height),
        RectF(0, 0, TARGET_WIDTH, TARGET_HEIGHT),
        1, True);
    finally
      imgPhoto.Bitmap.Canvas.EndScene;
    end;
  finally
    TempBitmap.Free;
  end;
end;

{ Layout Responsiveness adjuster }
procedure TfPatientModal.EditComponentsResponsive;
begin
  lytFullName.Width := Trunc(lytDetails1.Width / 2) - 15; // -15 to account for spacing
  lytDateOfBirth.Width := Trunc(lytDetails1.Width / 2) - 15;
  lytGender.Width := Trunc(lytDetails2.Width / 2) - 15;
  lytContactNumber.Width := Trunc(lytDetails2.Width / 2) - 15;
  lytEmailAddress.Width := Trunc(lytDetails3.Width / 2) - 15;
  lytAddress.Width := Trunc(lytDetails3.Width / 2) - 15;
end;

{ Frame Resize }
procedure TfPatientModal.FrameResize(Sender: TObject);
begin
  EditComponentsResponsive;

  if (frmMain.ClientWidth >= 1920) then
  begin
    rModalInfo.Margins.Left := 530;
    rModalInfo.Margins.Right := 530;
    rModalInfo.Margins.Top := 200;
    rModalInfo.Margins.Bottom := 200;
  end
  else if (frmMain.ClientWidth >= 1366) then
  begin
    rModalInfo.Margins.Left := 300;
    rModalInfo.Margins.Right := 300;
    rModalInfo.Margins.Top := 90;
    rModalInfo.Margins.Bottom := 90;
  end
  else if (frmMain.ClientHeight <= 510) AND (frmMain.ClientWidth <= 860) then
  begin
    rModalInfo.Margins.Left := 90;
    rModalInfo.Margins.Right := 90;
    rModalInfo.Margins.Top := 50;
    rModalInfo.Margins.Bottom := 50;
  end;
end;

{ Clear items for add patient modal }
procedure TfPatientModal.ClearItems;
begin
  // Clear Fields
  cProfilePhoto.Fill.Bitmap.Bitmap := nil;  // Clear Image
  cProfilePhoto.Fill.Kind := TBrushKind.Solid;  // Set to solid
  gIcon.ImageIndex := 10;
  eFullName.Text := '';

  // Date of Birth
  deDateOfBirth.TodayDefault := True;
  deDateOfBirth.TextSettings.FontColor := TAlphaColors.White;
  lDateText.Visible := True;
  lDateText.FontColor := TAlphaColorRec.Gray;
  deDateOfBirth.DateFormatKind := TDTFormatKind.Short;

  // Font color Style settings of Date of Birth
  deDateOfBirth.StyledSettings :=
  deDateOfBirth.StyledSettings - [TStyledSetting.FontColor];

  // Reset Age
  lAgeCounter.Text := 'Age: 0 years';

  cbGender.ItemIndex := 0;
  eContactNumber.Text := '';
  eEmailAddress.Text := '';
  eAddress.Text := '';

  // Medical notes
  mMedicalNotes.Text := 'Enter any relevant medical history, allergies, or notes';
  MemoTrackingReset := 'Empty';
  mMedicalNotes.TextSettings.FontColor := TAlphaColorRec.Gray;

  // Hide all warning validation
  crContactNumber.Visible := False;
  crFullName.Visible := False;

  // Button Visibility
  if dm.User.RoleH = 'Admin' then
  begin
    btnDelete.Visible := True;
  end
  else
  begin
    btnDelete.Visible := False;
  end;

  ScrollBox1.ViewportPosition := PointF(0, 0);  // Reset scrollbox
end;

{ Save Button }
procedure TfPatientModal.btnSavePatientClick(Sender: TObject);
var
  ms: TMemoryStream;
  HasError: Boolean;
begin
  HasError := False;

  // FullName validation
  if eFullName.Text = '' then
  begin
    crFullName.Visible := True;
    HasError := True;
  end
  else
    crFullName.Visible := False;

  // Date of birth validation
  if lDateText.Text = '' then
  begin
    crDateOfBirth.Visible := True;
    HasError := True;
  end
  else
    crDateOfBirth.Visible := False;

  // Contact Number validation
  if eContactNumber.Text = '' then
  begin
    crContactNumber.Visible := True;
    HasError := True;
  end
  else
    crContactNumber.Visible := False;

  // Stop if any error is found
  if HasError = True then
  begin
    Exit;
  end;

  // Handle record state
  if dm.RecordStatus = 'Add' then
    dm.qPatients.Append
  else
    dm.qPatients.Edit;

  // Field to save
  dm.qPatients.FieldByName('fullname').AsString := eFullName.Text;
  dm.qPatients.FieldByName('birth_date').AsDateTime := deDateOfBirth.Date;

  // Save formatted date as "mmm dd, yyyy" e.g. "Nov 13, 2025"
  dm.qPatients.FieldByName('date_long').AsString := FormatDateTime('mmm dd, yyyy', deDateOfBirth.Date);

  dm.qPatients.FieldByName('gender').AsString := cbGender.Text;
  dm.qPatients.FieldByName('contact_number').AsString := eContactNumber.Text;
  dm.qPatients.FieldByName('email_address').AsString := eEmailAddress.Text;
  dm.qPatients.FieldByName('address').AsString := eAddress.Text;

  // Set Medical Notes to empty
  if mMedicalNotes.Text = 'Enter any relevant medical history, allergies, or notes' then
    mMedicalNotes.Text := '';
  dm.qPatients.FieldByName('medical_notes').AsString := mMedicalNotes.Text;

  // Save image to LONGBLOB
  if Assigned(cProfilePhoto.Fill.Bitmap.Bitmap) and not cProfilePhoto.Fill.Bitmap.Bitmap.IsEmpty then
  begin
    ms := TMemoryStream.Create;
    try
      cProfilePhoto.Fill.Bitmap.Bitmap.SaveToStream(ms);
      ms.Position := 0;
      TBlobField(dm.qPatients.FieldByName('profile_photo')).LoadFromStream(ms);
    finally
      ms.Free;
    end;
  end;

  dm.qPatients.Post;
  dm.qPatients.Refresh;
  ClearItems; // Clear fields

  // Set record pop up message
  if dm.RecordStatus = 'Add' then
    frmMain.Tag := 0
  else
    frmMain.Tag := 1;

  frmMain.RecordMessage('Patient', 'patient');
  frmMain.fPatients.PatientRecords;

  // Hide patient modal
  Self.Visible := False;
end;

{ Show captured photo }
procedure TfPatientModal.cProfilePhotoClick(Sender: TObject);
begin
  if cProfilePhoto.Fill.Kind = TBrushKind.Bitmap then
  begin
    // Show Captured photo
    rCameralModal.Visible := True;

    // Show Label in camera modal
    lPreviewImage.Visible := True;

    // Hide component
    lytImgTools.Visible := False;

    // Adjust lytPaintBox height
    lytPaintBox.Margins.Bottom := 45;
    lytPaintBox.Margins.Left := 60;
    lytPaintBox.Margins.Right := 60;
    lytPaintBox.Margins.Top := 25;

    // Dispaly the image
    imgPhoto.Bitmap.Assign(cProfilePhoto.Fill.Bitmap.Bitmap);
  end;
end;

{ Profile Changer }
procedure TfPatientModal.cProfilePhotoPainting(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  if cProfilePhoto.Fill.Kind = TBrushKind.Bitmap then
    lNameH.Visible := False
  else if (not gIcon.ImageIndex = 10 ) AND (cProfilePhoto.Fill.Kind = TBrushKind.Solid) then
    lNameH.Visible := True;
end;

{ Take picture }
procedure TfPatientModal.btnTakePictureClick(Sender: TObject);
begin
  if not FStatus then
  begin
    btnTakePicture.Text := 'Retake photo';  // Change caption of the button
    FStatus := True;  // Camera component status
    ccCapturePhoto.Active := False; // Disable the camera component
    cProfilePhoto.Fill.Bitmap.Bitmap.Assign(imgPhoto.Bitmap);  // Show captured image on the image holder
  end
  else
  begin
    // Run the camera activation after a 3-second delay in a background thread
    TThread.CreateAnonymousThread(
      procedure
      begin
        ccCapturePhoto.Active := True;
        FCapturing := True;

        // Wait for 1.5 seconds
        TThread.Sleep(1500);

        // Execute the rest of the code on the main UI thread
        TThread.Synchronize(nil,
          procedure
          begin
            // Show captured image on the image holder
            cProfilePhoto.Fill.Bitmap.Bitmap.Assign(imgPhoto.Bitmap);

            // Disable the camera component
            ccCapturePhoto.Active := False;
          end);
      end).Start;
  end;
  cProfilePhoto.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;  // Wrapmode set to stretch
  cProfilePhoto.Cursor := crHandPoint;  // Change cursor
  gIcon.ImageIndex := -1; // Hide Icon
  lNameH.Visible := False;  // Hide Name holder
end;

{ Upload Photo }
procedure TfPatientModal.btnUploadClick(Sender: TObject);
var
  LOpenDialog: TOpenDialog;
begin
  LOpenDialog := TOpenDialog.Create(Self);
  try
    // Filter for image types
    LOpenDialog.Filter := 'Image Files|*.bmp;*.jpg;*.jpeg;*.png|All Files|*.*';
    LOpenDialog.Title := 'Select a photo to upload';

    if LOpenDialog.Execute then
    begin
      // ✅ Load the selected file into the TImage
      cProfilePhoto.Fill.Bitmap.Bitmap.LoadFromFile(LOpenDialog.FileName);
      cProfilePhoto.Fill.Kind := TBrushKind.Bitmap;
      cProfilePhoto.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
      cProfilePhoto.Cursor := crHandPoint;  // Change cursor

      lNameH.Visible := False;  // Hide Name holder
      gIcon.ImageIndex := -1; // Hide Icon
    end;
  finally
    LOpenDialog.Free;
  end;
end;

{ Save current image }
procedure TfPatientModal.btnSaveCurrentImageClick(Sender: TObject);
begin
  if (imgPhoto.Bitmap <> nil) and not imgPhoto.Bitmap.IsEmpty then
  begin
    sdSavePicture.Filter := 'PNG Image|*.png|JPEG Image|*.jpg|Bitmap Image|*.bmp';
    sdSavePicture.DefaultExt := 'png';
    sdSavePicture.FileName := 'CapturedImage.png';

    if sdSavePicture.Execute then
    begin
      imgPhoto.Bitmap.SaveToFile(sdSavePicture.FileName);
      ShowMessage('Image saved to: ' + sdSavePicture.FileName);
    end;
  end
  else
    ShowMessage('No image to save.');
end;

{ Camera component buffer }
procedure TfPatientModal.ccCapturePhotoSampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
  TThread.Synchronize(nil, ShowCameraFrame);
end;

{ Date display and age calculation }
procedure TfPatientModal.deDateOfBirthChange(Sender: TObject);
var
  DOB, Today: TDate;
  Age: Integer;
begin
  if Self.Visible then
  begin
    // UI tweaks
    lDateText.Text := FormatDateTime('mmm dd, yyyy', deDateOfBirth.Date);
    deDateOfBirth.TodayDefault := False;

    // Get the date value (TDateEdit.Date is safer than parsing Text)
    DOB := deDateOfBirth.Date;
    Today := Date;

    // Validate
    if (DOB <= 0) or (DOB > Today) then
    begin
      lAgeCounter.Text := 'Age: 0 years';
      Exit;
    end;

    // Basic year difference
    Age := YearOf(Today) - YearOf(DOB);

    // If birthday this year hasn't happened yet, subtract 1
    if (MonthOf(Today) < MonthOf(DOB)) or
     ((MonthOf(Today) = MonthOf(DOB)) and (DayOf(Today) < DayOf(DOB))) then
    Dec(Age);

    if Age < 0 then
      Age := 0; // defensive

    lAgeCounter.Text := Format('Age: %d years', [Age]);
  end;
end;

{ OnCheckChanged Birth date }
procedure TfPatientModal.deDateOfBirthCheckChanged(Sender: TObject);
begin
  if deDateOfBirth.Date = Now then
  begin
    // Set date
    lDateText.Text := FormatDateTime('mmm dd, yyyy', deDateOfBirth.Date)
  end;
end;

{ OnClosePicker Birth date }
procedure TfPatientModal.deDateOfBirthClosePicker(Sender: TObject);
begin
  lDateText.Visible := True;
  lDateText.TextSettings.FontColor := TAlphaColorRec.Black;
  deDateOfBirth.StyledSettings := [TStyledSetting.Style];
  deDateOfBirth.ResetFocus;
end;

{ OnEnter Birth date }
procedure TfPatientModal.deDateOfBirthEnter(Sender: TObject);
begin
  lDateText.Visible := False;
  deDateOfBirth.CanFocus := True;
  deDateOfBirth.StyledSettings := [TStyledSetting.Style, TStyledSetting.FontColor];
end;

{ OnExit Birth date }
procedure TfPatientModal.deDateOfBirthExit(Sender: TObject);
begin
  lDateText.Visible := True;
  deDateOfBirth.StyledSettings := [TStyledSetting.Style];
end;

{ OnOpenPicker Birth date }
procedure TfPatientModal.deDateOfBirthOpenPicker(Sender: TObject);
begin
  lDateText.Visible := True;
  deDateOfBirth.StyledSettings := [TStyledSetting.Style]
end;

{ Camera button }
procedure TfPatientModal.btnCameraClick(Sender: TObject);
begin
  FCapturing := False;
  FStatus := False;
  UpdateCameraList;

  cProfilePhoto.Fill.Kind := TBrushKind.Bitmap;

  // Adjust lytPaintBox height
  lytPaintBox.Margins.Bottom := 20;
  lytPaintBox.Margins.Left := 70;
  lytPaintBox.Margins.Right := 70;
  lytPaintBox.Margins.Top := 10;

  // Hide label in camera modal
  lPreviewImage.Visible := False;

  // Show Capture photo modal
  rCameralModal.Visible := True;

  // Show components
  lytImgTools.Visible := True;

  if not FCapturing then
  begin
    ccCapturePhoto.Kind := TCameraKind.Default;  // or ckBackCamera
    ccCapturePhoto.Active := True;
    FCapturing := True;
  end
  else
  begin
    ccCapturePhoto.Active := False;
    FCapturing := False;
  end;
end;

{ Close Camera }
procedure TfPatientModal.btnCameraCloseClick(Sender: TObject);
begin
  rCameralModal.Visible := False;
  ccCapturePhoto.Active := False;
  FCapturing := False;
end;

{ Cancel button }
procedure TfPatientModal.btnCancelClick(Sender: TObject);
begin
  Self.Visible := False;
end;

{ Close button }
procedure TfPatientModal.btnCloseClick(Sender: TObject);
begin
  Self.Visible := False;
end;

{ Delete Patient Button }
procedure TfPatientModal.btnDeletePatientClick(Sender: TObject);
begin
  dm.qPatients.Delete;
  dm.qPatients.Refresh;

  // Set record pop up message
  frmMain.Tag := 5;
  frmMain.RecordMessage('Patient', eFullName.Text);

  rDeleteBackground.Visible := False;
  Self.Visible := False;
end;

{ Cancel Button - Delete }
procedure TfPatientModal.btnDeleteCancelClick(Sender: TObject);
begin
  rDeleteBackground.Visible := False;
end;

{ Delete Button }
procedure TfPatientModal.btnDeleteClick(Sender: TObject);
begin
  rDeleteBackground.Visible := True;
  lDeleteDesc.Text := 'Are you sure you want to delete ' + eFullName.Text + '? This action cannot be undone.'
end;

{ Close Button - Delete }
procedure TfPatientModal.btnDeleteCloseClick(Sender: TObject);
begin
  rDeleteBackground.Visible := False;
end;

{ Email Address Onchange }
procedure TfPatientModal.eEmailAddressChangeTracking(Sender: TObject);
begin
  // Style setter
  if eEmailAddress.Text = '' then
    eEmailAddress.StyledSettings := [TStyledSetting.Style]
  else
    eEmailAddress.StyledSettings := [];
end;

{ Patient profile setter & fullname warning reset }
procedure TfPatientModal.eFullNameChangeTracking(Sender: TObject);
var
  Parts: TArray<string>;
  Initials: string;
begin
  // Getter of first letter of the Full name
  if eFullName.Text.Trim <> '' then
  begin
    Parts := eFullName.Text.Trim.Split([' ']); // split by space
    Initials := '';

    // First letter of first word
    if Length(Parts) >= 1 then
      Initials := Initials + UpperCase(Parts[0][1]);

    // First letter of second word
    if Length(Parts) >= 2 then
      Initials := Initials + UpperCase(Parts[1][1]);

    lNameH.Text := Initials;

    // Profile pic changer
    gIcon.ImageIndex := -1;
    lNameH.Visible := True;
  end;

  if (eFullName.Text.Trim = '') AND (cProfilePhoto.Fill.Kind = TBrushKind.Solid) then
  begin
    lNameH.Text := '';
    gIcon.ImageIndex := 10;
    lNameH.Visible := False;

    // Style setter
    eFullName.StyledSettings := [TStyledSetting.Style]
  end
  else
    eFullName.StyledSettings := [];

  // Fullname warning reset
  crFullName.Visible := False;
end;

{ Address Onchange }
procedure TfPatientModal.eAddressChangeTracking(Sender: TObject);
begin
  // Style setter
  if eAddress.Text = '' then
    eAddress.StyledSettings := [TStyledSetting.Style]
  else
    eAddress.StyledSettings := [];
end;

{ Contact Number Onchange }
procedure TfPatientModal.eContactNumberChangeTracking(Sender: TObject);
begin
  // Style setter
  if eContactNumber.Text = '' then
    eContactNumber.StyledSettings := [TStyledSetting.Style]
  else
    eContactNumber.StyledSettings := [];

  // Contact number warning reset
  crContactNumber.Visible := False;
end;

{ Details 1 responsive }
procedure TfPatientModal.lytDetails1Resize(Sender: TObject);
begin
  EditComponentsResponsive;
end;

{ Details 2 responsive }
procedure TfPatientModal.lytDetails2Resize(Sender: TObject);
begin
  EditComponentsResponsive;
end;

{ Details 3 responsive }
procedure TfPatientModal.lytDetails3Resize(Sender: TObject);
begin
  EditComponentsResponsive;
end;

{ Medical memo text prompt remover }
procedure TfPatientModal.mMedicalNotesClick(Sender: TObject);
begin
  if mMedicalNotes.Text = 'Enter any relevant medical history, allergies, or notes' then
  begin
    MemoTrackingReset := 'Clicked';
    mMedicalNotes.Text := '';
    mMedicalNotes.FontColor := TAlphaColorRec.Black;
  end;

  lTag.Text := 'Tag Number : ' + MemoTrackingReset;
end;

{ Medical memo text prompt inserter }
procedure TfPatientModal.mMedicalNotesExit(Sender: TObject);
begin
  if (MemoTrackingReset = 'Clicked') AND (mMedicalNotes.Text.Trim.IsEmpty) then
  begin
    MemoTrackingReset := 'Empty';
  end;

  if (MemoTrackingReset = 'Empty') then
  begin
    mMedicalNotes.Text := 'Enter any relevant medical history, allergies, or notes';
    mMedicalNotes.FontColor := TAlphaColorRec.Gray;
  end;

  lTag.Text := 'Tag Number : ' + MemoTrackingReset;
end;

end.
