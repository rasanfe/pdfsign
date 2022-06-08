using System;
using System.Text;
using iTextSharp.text.pdf;
using System.IO;
using iTextSharp.text.pdf.security;
using Org.BouncyCastle.Pkcs;



namespace NetPdfService
{
    public class PdfService
    {
        private string errorText = "";
        public void Firmar(string inFile, string outFile, string certFile, string password, string reason, string location, string contact, string imgeFile, int x1, int y1, int x2, int y2, string nombre, string dni)
        {
            ResetError();
            const bool isVisible = true;

            if (String.IsNullOrEmpty(imgeFile))
            {
                errorText = "Image File cannot be null";
                throw new ArgumentNullException(paramName: nameof(imgeFile), message: errorText);
            }

            if (String.IsNullOrWhiteSpace(nombre)) { nombre = ""; }
            if (String.IsNullOrWhiteSpace(nombre)) { dni = ""; }

            Firmar(inFile, outFile, certFile, password, reason, location, contact, imgeFile, x1, y1, x2, y2, nombre, dni, isVisible);
        }
        public void Firmar(string inFile, string outFile, string certFile, string password, string reason, string location, string contact)
        {
            ResetError();
            const string imgeFile = "";
            const int x1 = 0;
            const int y1 = 0;
            const int x2 = 0;
            const int y2 = 0;
            const string nombre = "";
            const string dni = "";
            const bool visible = false;

            Firmar(inFile, outFile, certFile, password, reason, location, contact, imgeFile, x1, y1, x2, y2, nombre, dni, visible);
        }

        internal void Firmar(string inFile, string outFile, string certFile, string password, string reason, string location, string contact, string imgeFile, int x1, int y1, int x2, int y2, string nombre, string dni, bool isVisible)
        {
            if (String.IsNullOrEmpty(inFile))
            {
                errorText = "Input File cannot be null";
                throw new ArgumentNullException(paramName: nameof(inFile), message: errorText);
            }
            if (Path.GetExtension(inFile)!=".pdf")
            {
                errorText = "Input File Extension is not PDF";
                throw new ArgumentException(paramName: nameof(inFile), message: errorText);
            }

            if (String.IsNullOrEmpty(outFile))
            {
                errorText = "Output File cannot be null";
                throw new ArgumentNullException(paramName: nameof(outFile), message: errorText);
            }
            if (Path.GetExtension(outFile) != ".pdf")
            {
                errorText = "Output File Extension is not PDF";
                throw new ArgumentException(paramName: nameof(inFile), message: errorText);
            }
            if (String.IsNullOrEmpty(certFile))
            {
                errorText = "Certificate File File cannot be null";
                throw new ArgumentNullException(paramName: nameof(certFile), message: errorText);
            }
            if (Path.GetExtension(certFile) != ".pfx")
            {
                errorText = "Certificate File Extension is not PFX";
                throw new ArgumentException(paramName: nameof(inFile), message: errorText);
            }
            if (String.IsNullOrEmpty(password))
            {
                errorText = "Password cannot be null";
                throw new ArgumentNullException(paramName: nameof(password), message: errorText);
            }

            if (String.IsNullOrWhiteSpace(reason)) { reason = "proof of authenticity"; }

            try
            {
                PdfReader reader = new PdfReader(inFile);

                int numberOfPages = reader.NumberOfPages;

                FileStream fout = new FileStream(outFile, FileMode.Create, FileAccess.ReadWrite);

                // appearance
                PdfStamper stamper = PdfStamper.CreateSignature(reader, fout, '\0', null, true);
                PdfSignatureAppearance appearance = stamper.SignatureAppearance;

                //Determinamos la Fecha de la certFile
                DateTime fechaFirma = DateTime.Now;

                appearance.SignDate = fechaFirma;
                appearance.Location = @location;
                appearance.Reason = @reason;
                appearance.Contact = @contact;

                //Posicion de la certFile en el PDF
                var rectangle = new iTextSharp.text.Rectangle(x1, y1, x2, y2);

                if (isVisible)
                {
                    //La Firma será Visible y en la Ultima página del PDF
                    appearance.Image = iTextSharp.text.Image.GetInstance(imgeFile);
                    appearance.SetVisibleSignature(rectangle, numberOfPages, null);
                    appearance.Image.ScaleToFit(rectangle);
                    appearance.Image.SetAbsolutePosition(290, 0); //align it center
                    appearance.ImageScale = 0.22f;
                    appearance.Image.Alignment = 300;

                    //Añadimos el Nombre y el DNI en la firma como Texto.
                    StringBuilder buf = new StringBuilder();
                    buf.Append('\n').Append('\n').Append('\n').Append('\n').Append(@nombre).Append('\n').Append(@dni);
                    string text = buf.ToString();

                    appearance.Layer2Text = text;
                }
                else
                {
                    //La Firma es Invisible
                    appearance.IsInvisible();
                }
                appearance.Acro6Layers = true;

                var pk12 = new Pkcs12Store(new System.IO.FileStream(certFile, System.IO.FileMode.Open, System.IO.FileAccess.Read), password.ToCharArray());
                string alias = null;
                foreach (string tAlias in pk12.Aliases)
                {
                    if (pk12.IsKeyEntry(tAlias))
                    {
                        alias = tAlias;
                        break;
                    }
                }
                var pk = pk12.GetKey(alias).Key;

                //Digital Signature
                IExternalSignature es = new PrivateKeySignature(pk, "SHA-256");

                MakeSignature.SignDetached(appearance, es, new Org.BouncyCastle.X509.X509Certificate[] { pk12.GetCertificate(alias).Certificate }, null, null, null, 0, CryptoStandard.CMS);

                stamper.Close();
                stamper.Dispose();
                reader.Close();
                reader.Dispose();
                fout.Close();
                fout.Dispose();
            }
            catch (Exception ex)
            {
                errorText = ex.Message;
            }
        }

        public string GetLastError()
        {
            return errorText;
        }
        internal void ResetError()
        {
            errorText = "";
        }

    }
}
