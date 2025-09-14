unit uPatientModal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ImgList, FMX.Controls.Presentation,
  FMX.Memo.Types, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl, FMX.TMSFNCWebBrowser,
  FMX.TMSFNCCustomWEBControl, FMX.TMSFNCMemo, FMX.ScrollBox, FMX.Memo,
  FMX.DateTimeCtrls, FMX.Edit, FMX.ListBox, Data.DB, FMX.Media, FCamera,
  FMX.MediaLibrary, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, FMX.DialogService, System.DateUtils;

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
    lGenderText: TLabel;
    lDateText: TLabel;
    btnCamera: TCornerButton;
    btnCancel: TCornerButton;
    imgProfilePhoto: TImage;
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
    lCameraDesc: TLabel;
    rImageFrame: TRectangle;
    procedure mMedicalNotesClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure eFullNameChangeTracking(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure lytDetails1Resize(Sender: TObject);
    procedure lytDetails2Resize(Sender: TObject);
    procedure lytDetails3Resize(Sender: TObject);
    procedure cbGenderChange(Sender: TObject);
    procedure mMedicalNotesExit(Sender: TObject);
    procedure deDateOfBirthChange(Sender: TObject);
    procedure btnSavePatientClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCameraClick(Sender: TObject);
    procedure btnCameraCloseClick(Sender: TObject);
    procedure ccCapturePhotoSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure btnTakePictureClick(Sender: TObject);
    procedure cbCameraOptionChange(Sender: TObject);
    procedure imgProfilePhotoClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
  private
    FCapturing: Boolean;
    FStatus: Boolean;
    procedure UpdateCameraList;
    procedure ShowCameraFrame;
    { Private declarations }
  public
    MemoTrackingReset: String;
    procedure EditComponentsResponsive;
    { Public declarations }
  end;

  const
  TARGET_WIDTH  = 320;
  TARGET_HEIGHT = 240;

implementation

{$R *.fmx}

uses uMain, uDm;

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

{ Modal Frame Resize }
procedure TfPatientModal.FrameResize(Sender: TObject);
begin
  // Modal content margins
  if (frmMain.ClientHeight >= 520) AND (frmMain.ClientWidth >= 870) then
  begin
    rModalInfo.Margins.Left := 310;
    rModalInfo.Margins.Right := 310;
    rModalInfo.Margins.Top := 60;
    rModalInfo.Margins.Bottom := 60;
  end;

  if (frmMain.ClientHeight <= 510) AND (frmMain.ClientWidth <= 860) then
  begin
    rModalInfo.Margins.Left := 70;
    rModalInfo.Margins.Right := 70;
    rModalInfo.Margins.Top := 30;
    rModalInfo.Margins.Bottom := 30;
  end;
end;

{ Show captured photo }
procedure TfPatientModal.imgProfilePhotoClick(Sender: TObject);
begin
  // Show Captured photo
  rCameralModal.Visible := True;

  // Hide component
  lytImgTools.Visible := False;

  // Adjust lytPaintBox height
  lytPaintBox.Margins.Bottom := 45;
  lytPaintBox.Margins.Left := 60;
  lytPaintBox.Margins.Right := 60;
  lytPaintBox.Margins.Top := 25;

  // Dispaly the image
  imgPhoto.Bitmap.Assign(imgProfilePhoto.Bitmap);
end;

{ Save Button }
procedure TfPatientModal.btnSavePatientClick(Sender: TObject);
var
  ms: TMemoryStream;
begin
  dm.qPatients.Append;

  // Field to save
  dm.qPatients.FieldByName('fullname').AsString := eFullName.Text;
  dm.qPatients.FieldByName('birth_date').AsDateTime := deDateOfBirth.Date;
  dm.qPatients.FieldByName('gender').AsString := cbGender.Text;
  dm.qPatients.FieldByName('contact_number').AsString := eContactNumber.Text;
  dm.qPatients.FieldByName('email_address').AsString := eEmailAddress.Text;
  dm.qPatients.FieldByName('address').AsString := eAddress.Text;
  dm.qPatients.FieldByName('medical_notes').AsString := mMedicalNotes.Text;

  // Save image to LONGBLOB
  if Assigned(imgProfilePhoto.Bitmap) and not imgProfilePhoto.Bitmap.IsEmpty then
  begin
    ms := TMemoryStream.Create;
    try
      imgProfilePhoto.Bitmap.SaveToStream(ms);
      ms.Position := 0;
      TBlobField(dm.qPatients.FieldByName('profile_photo')).LoadFromStream(ms);
    finally
      ms.Free;
    end;
  end;

  dm.qPatients.Post;
  dm.qPatients.Refresh;
end;

{ Take picture }
procedure TfPatientModal.btnTakePictureClick(Sender: TObject);
begin
  if not FStatus then
  begin
    btnTakePicture.Text := 'Retake photo';
    FStatus := True;

    // Show captured image on the image holder
    imgProfilePhoto.Bitmap.Assign(imgPhoto.Bitmap);

    // Disable the camera component
    ccCapturePhoto.Active := False;

    // Show captured image
    imgProfilePhoto.Visible := True;

    // Hide Icon for no captured image
    gIcon.Visible := False;

    // Show Image frame
    rImageFrame.Visible := True;
  end
  else
  begin
    // Run the camera activation after a 3-second delay in a background thread
    TThread.CreateAnonymousThread(
      procedure
      begin
        ccCapturePhoto.Active := True;
        FCapturing := True;

        // Wait for 3 seconds
        TThread.Sleep(1500);

        // Execute the rest of the code on the main UI thread
        TThread.Synchronize(nil,
          procedure
          begin
            // Show captured image on the image holder
            imgProfilePhoto.Bitmap.Assign(imgPhoto.Bitmap);

            // Disable the camera component
            ccCapturePhoto.Active := False;
          end);
      end).Start;
  end;
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
      imgProfilePhoto.Bitmap.LoadFromFile(LOpenDialog.FileName);
    end;
  finally
    LOpenDialog.Free;
    rImageFrame.Visible := True;

  end;
end;

{ Gender display dropdown }
procedure TfPatientModal.cbCameraOptionChange(Sender: TObject);
begin
  lCameraDesc.Text := cbCameraOption.Text;
end;

procedure TfPatientModal.cbGenderChange(Sender: TObject);
begin
  lGenderText.Text := cbGender.Text;
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
  DOB: TDate;
  Age: Integer;
  Today: TDate;
begin
  // Style updates
  deDateOfBirth.TextSettings.FontColor := TAlphaColors.Black;
  lDateText.Visible := False;

  // Directly use the Date property of TDateEdit
  DOB := deDateOfBirth.Date;
  Today := Date;

  // Calculate age
  Age := YearsBetween(Today, DOB);

  // Adjust if birthday hasn't occurred yet this year
  if (MonthOf(Today) < MonthOf(DOB)) or
     ((MonthOf(Today) = MonthOf(DOB)) and (DayOf(Today) < DayOf(DOB))) then
    Dec(Age);

  lAgeCounter.Text := 'Age: ' + Age.ToString + ' years';
end;

{ Camera button }
procedure TfPatientModal.btnCameraClick(Sender: TObject);
begin
  FCapturing := False;
  FStatus := False;
  UpdateCameraList;

  // Adjust lytPaintBox height
  lytPaintBox.Margins.Bottom := 20;
  lytPaintBox.Margins.Left := 70;
  lytPaintBox.Margins.Right := 70;
  lytPaintBox.Margins.Top := 10;

  // Show Capture photo modal
  rCameralModal.Visible := True;

  // Show components
  lytImgTools.Visible := True;

  // Set the current camera used
  lCameraDesc.Text := cbCameraOption.Text;

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

{ Patient profile setter }
procedure TfPatientModal.eFullNameChangeTracking(Sender: TObject);
begin
  // Getter of first letter of the Full name
  if eFullName.Text.Trim <> '' then
  begin
    lNameH.Text := UpperCase(eFullName.Text.Trim[1]);

    // Profile pic changer
    gIcon.ImageIndex := -1;
    lNameH.Visible := True;
  end;

  if eFullName.Text.Trim = '' then
  begin
    lNameH.Text := '';
    gIcon.ImageIndex := 10;
    lNameH.Visible := False;
  end;
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
  if MemoTrackingReset = 'Empty' then
  begin
    MemoTrackingReset := 'Clicked';
    mMedicalNotes.Text := '';
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
  end;

  lTag.Text := 'Tag Number : ' + MemoTrackingReset;
end;

end.
