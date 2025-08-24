unit uPatientModal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ImgList, FMX.Controls.Presentation,
  FMX.Memo.Types, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl, FMX.TMSFNCWebBrowser,
  FMX.TMSFNCCustomWEBControl, FMX.TMSFNCMemo, FMX.ScrollBox, FMX.Memo,
  FMX.DateTimeCtrls, FMX.Edit, FMX.ListBox, Data.DB, FMX.Media, FCamera;

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
    cCapturePhoto: TFCamera;
    rCameralModal: TRectangle;
    imgPreview: TImage;
    lytImgTools: TLayout;
    Timer1: TTimer;
    Layout2: TLayout;
    lCamera: TLabel;
    cbCamera: TComboBox;
    lFormat: TLabel;
    cbFormat: TComboBox;
    btnTakePicture: TCornerButton;
    btnSaveCurrentImage: TCornerButton;
    Layout1: TLayout;
    btnCameraClose: TSpeedButton;
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
    procedure ccCaptureSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure btnSaveCurrentImageClick(Sender: TObject);
    procedure btnCameraCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    FCapturedImage: TBitmap;
    MemoTrackingReset: String;
    procedure EditComponentsResponsive;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uMain, uDm;

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

{ Save Image }
procedure TfPatientModal.btnSaveCurrentImageClick(Sender: TObject);
begin
  cCapturePhoto.CurrentImageToFile('image.bmp');
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

{ Gender display dropdown }
procedure TfPatientModal.cbGenderChange(Sender: TObject);
begin
  lGenderText.Text := cbGender.Text;
end;

{ Date display }
procedure TfPatientModal.deDateOfBirthChange(Sender: TObject);
begin
  deDateOfBirth.TextSettings.FontColor := TAlphaColors.Black;
  lDateText.Visible := False;
end;

{ Camera button }
procedure TfPatientModal.btnCameraClick(Sender: TObject);
begin
  rCameralModal.Visible := True;
end;

{ Close Camera }
procedure TfPatientModal.btnCameraCloseClick(Sender: TObject);
begin
  rCameralModal.Visible := False;
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
