using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

	public partial class Form1 : Form
	{
		int distance = 30, mouse = 0;
		int mouseX, mouseY, mouseCX, mouseCY, mouseSCX, mouseSCY;
		bool position = false;
		bool capture = false, start = false;
		char type = 'R';
		string text = "No Entry";

		public Form1()
		{
			InitializeComponent();
		}

		// Programm Starten
		private void buttonStart_Click(object sender, EventArgs e)
		{
			// Werte einlesen
			text = textBoxText.Text;

			if (radioButtonR.Checked)
			{
				distance = 30;
				mouse = 0;
				type = 'R';
				position = false;
			}
			else if (radioButtonL.Checked)
			{
				distance = 30;
				mouse = 0;
				type = 'L';
				position = false;
			}
			else if (radioButtonC.Checked)
			{
				distance = 30;
				mouse = 0;
				type = 'C';
				position = false;
			}

			// Picture Box Initialisieren
			start = true;
			pictureBoxDraw.Invalidate();

		}

		// Textbox vor Eingabe leeren
		private void textBoxText_Enter(object sender, EventArgs e)
		{
			textBoxText.Text = null;
		}

		private void pictureBoxDraw_MouseClick(object sender, MouseEventArgs e)
		{
			// Mausklick erfassen
			MouseEventArgs eventMouse = (MouseEventArgs)e;
			mouseCX = eventMouse.X;
			mouseCY = eventMouse.Y;

			// Zeiger nach Mausklick erhöhen
			if (mouse == 0)
				mouse++;
			// Erster Mausklick feststellen
			else if (mouse == 1)
			{
				mouse++;
			}
			// Zweiter Mausklick rücksetzen
			else
			{
				mouse = 0;
			}
			// Invalidieren (neu Zeichnen)
			pictureBoxDraw.Invalidate();
		}

		private void pictureBoxDraw_MouseMove(object sender, MouseEventArgs e)
		{
			capture = true;

			MouseEventArgs eventMouse = (MouseEventArgs)e;
			mouseX = eventMouse.X;
			mouseY = eventMouse.Y;
			pictureBoxDraw.Invalidate();
		}


		// Zeichenplatte
		private void pictureBoxDraw_Paint(object sender, PaintEventArgs e)
		{
			// Grafik Device erstellen und Kantenglättung aktivieren
			Graphics dev = e.Graphics;
			dev.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

			// Font, Pinsel und Brushes aktivieren
			Font fontSTD = new Font("Verdana", 9);

			Pen blackP = Pens.Black;
			Brush blackB = Brushes.Black;

			// Startfreigabe überprüfen
			if (start == false)
				return;

			// Mauskoordinaten in rechter Ecke oben ausgeben
				dev.DrawString("X: " + mouseX.ToString(), fontSTD, blackB, pictureBoxDraw.Width - 50, 10);
				dev.DrawString("Y: " + (pictureBoxDraw.Height - mouseY).ToString(), fontSTD, blackB, pictureBoxDraw.Width - 50, 20);

			// Symbol an Maus anheften wenn keine Klicks erfolgt sind
			if (mouse == 0)
			{
				// Erklärung anzeigen
				dev.DrawString("Bauteil durch Mausklick positionieren", fontSTD, blackB, 20, 10);

				// Bauteil an Maus anheften
				drawRLC(dev, type, mouseX, mouseY, distance, position, text, fontSTD, blackP, blackB);
			}

			// Mausklick erfassen Objekt positionieren / größe anpassen
			if (mouse == 1)
			{
				// Erklärung anzeigen
				dev.DrawString("Bauteil über Maus skalieren und Ausrichtung einstellen", fontSTD, blackB, 20, 10);

				// Ausrichtung des Bauteils bestimmen
				if ((Math.Abs(mouseX - mouseCX)) >= (Math.Abs(mouseY - mouseCY)))
					position = false;
				else
					position = true;

				// Bauteil Zeichnen (Distanz variabel)
				drawRLC(dev, type, mouseCX, mouseCY, distance, position, text, fontSTD, blackP, blackB);
				
				// Bauteilgröße bestimmen
				if(position == false)
					distance = Math.Abs(mouseX - mouseCX);
				else if (position == true)
					distance = Math.Abs(mouseY - mouseCY);

				// Startposition speichern
				mouseSCX = mouseCX;
				mouseSCY = mouseCY;
			}
			else if (mouse == 2)
			{
				// Bauteil Fixieren
				drawRLC(dev, type, mouseSCX, mouseSCY, distance, position, text, fontSTD, blackP, blackB);
			}

			// Objekt zeichnen
			
			if (radioButtonR.Checked)
			{
				type = 'R';
			}


		}

		private void drawRLC(Graphics dev, char type, int x, int y, int distance, bool aligment, string text, Font style, Pen linestyle, Brush fillstyle )
		{
			int scale = 2;		// Skalierung der Bauteilanschlusslänge
			int offset = 10;    // Offset zwischen Bauteil und Text

			// Zeichenfolge Vertical zeichnen
			StringFormat drawVertical = new StringFormat(StringFormatFlags.DirectionVertical);

			if (type == 'R') {
				if (aligment == false) {
					dev.DrawLine(linestyle, x, y, (float)(x + (distance / scale)), y);
					dev.DrawRectangle(linestyle, x + (distance / scale), (float)(y - (distance / 4)), distance, (float)(distance / 2));
					dev.DrawLine(linestyle, (float)(x + distance + (distance / scale)), y, (float)(x + distance * 2), y);
					dev.DrawString(type + "_" + text, style, fillstyle, x + (distance / scale) + (distance / 2), y + offset + (float)(distance / 4));
				}
				if (aligment == true)
				{
					dev.DrawLine(linestyle, x, y, x, (float)(y - (distance / scale)));
					dev.DrawRectangle(linestyle, (float)(x - (distance / 4)), y - (distance / scale) - distance, (float)(distance / 2), distance);
					dev.DrawLine(linestyle, x, (float)(y - (distance + (distance / scale))), x, (float)(y - (distance * 2)));
					dev.DrawString(type + "_" + text, style, fillstyle, x + offset + (float)(distance / 4), y - (distance / scale) - (distance / 2), drawVertical);
				}
			}

			if (type == 'L')
			{
				if (aligment == false)
				{
					dev.DrawLine(linestyle, x, y, (float)(x + (distance / scale)), y);
					dev.FillRectangle(fillstyle, x + (distance / scale), (float)(y - (distance / 4)), distance, (float)(distance / 2));
					dev.DrawLine(linestyle, (float)(x + distance + (distance / scale)), y, (float)(x + distance * 2), y);
					dev.DrawString(type + "_" + text, style, fillstyle, x + (distance / scale) + (distance / 2), y + offset + (float)(distance / 4));
				}
				if (aligment == true)
				{
					dev.DrawLine(linestyle, x, y, x, (float)(y - (distance / scale)));
					dev.FillRectangle(fillstyle, (float)(x - (distance / 4)), y - (distance / scale) - distance, (float)(distance / 2), distance);
					dev.DrawLine(linestyle, x, (float)(y - (distance + (distance / scale))), x, (float)(y - (distance * 2)));
					dev.DrawString(type + "_" + text, style, fillstyle, x + offset + (float)(distance / 4), y - (distance / scale) - (distance / 2), drawVertical);
				}
			}

			if (type == 'C')
			{
				if (aligment == false)
				{
					dev.DrawLine(linestyle, x, y, (float)(x + distance) - (distance / (scale * 5)), y);
					dev.DrawLine(linestyle, (float)(x + distance) - (distance / (scale * 5)), (float)(y - (distance / 2)), (float)(x + distance) - (distance / (scale * 5)), (float)(y + (distance / 2)));
					dev.DrawLine(linestyle, (float)(x + distance + (distance / (scale * 5))), (float)(y - (distance / 2)), (float)(x + distance + (distance / (scale * 5))), (float)(y + (distance / 2)));
					dev.DrawLine(linestyle, (float)(x + distance + (distance / (scale * 5))), y, (float)(x + distance * 2), y);
					dev.DrawString(type + "_" + text, style, fillstyle, x + (distance / scale) + (distance / 2), y + offset + (float)(distance / 2));
				}
				if (aligment == true)
				{
					dev.DrawLine(linestyle, x, y, x, (float)(y - distance) + (distance / (scale * 5)));
					dev.DrawLine(linestyle, (float)(x - (distance / 2)), (float)(y - distance) + (distance / (scale * 5)), (float)(x + (distance / 2)), (float)(y - distance) + (distance / (scale * 5)));
					dev.DrawLine(linestyle, (float)(x - (distance / 2)), (float)(y - distance) - (distance / (scale * 5)), (float)(x + (distance / 2)), (float)(y - distance) - (distance / (scale * 5)));
					dev.DrawLine(linestyle, x, (float)(y - distance - (distance / (scale * 5))), x, (float)(y - distance * 2));
					dev.DrawString(type + "_" + text, style, fillstyle, x + offset + (float)(distance / 2), y - (distance / scale) - (distance / 2), drawVertical);
				}

			}

		}
	}