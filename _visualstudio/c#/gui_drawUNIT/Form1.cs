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
		int distance = 100, span = 20, mouse = 0;
		int mouseX, mouseY, mouseCX, mouseCY, mouseSCX, mouseSCY;
		double min, max;
		bool start = false, position = false, type = false;

		double measure = 0;
		string unit = "Einheit";

		string text;
		Color component;

		public Form1()
		{
			InitializeComponent();
		}

		private void textBoxUnit_Enter(object sender, EventArgs e)
		{
			// Textbox vor Eingabe leeren
			textBoxUnit.Text = null;
		}

		private void textBoxData_Enter(object sender, EventArgs e)
		{
			// Textbox vor Eingabe leeren
			textBoxData.Text = null;
		}

		private void textBoxText_Enter(object sender, EventArgs e)
		{
			// Textbox vor Eingabe leeren
			textBoxText.Text = null;
		}

		private void buttonColor_Click(object sender, EventArgs e)
		{
			if (colorDialogDevice.ShowDialog() == DialogResult.OK)
				component = colorDialogDevice.Color;
			buttonColor.BackColor = component;
		}

		private void buttonDo_Click(object sender, EventArgs e)
		{
			// Werte rücksetzen
			distance = 100;
			mouse = 0;
			type = false;

			// Feldmarkierungen rücksetzen
			textBoxUnit.BackColor = Color.White;
			textBoxData.BackColor = Color.White;
			numericUpDownMin.BackColor = Color.White;
			numericUpDownMax.BackColor = Color.White;
			component = buttonColor.BackColor;

			// Werte einlesen

			min = (double)(numericUpDownMin.Value);
			max = (double)(numericUpDownMax.Value);

			// Messwert umwandeln
			if (double.TryParse(textBoxData.Text, out measure))
			{
				if (textBoxUnit.Text == "" || textBoxUnit.Text == "Einheit")
				{
					textBoxUnit.Focus();
					textBoxUnit.BackColor = Color.Red;
					MessageBox.Show("Daten im Fehld Unit dürfen nicht leer oder Einheit sein!");
					return;
				}
				else
				{
					// Einheit speichern
					unit = textBoxUnit.Text;
				}

				// Überprüfung ob minimaler Messwert größer als Messwert
				if (min >= measure)
				{
					numericUpDownMin.Focus();
					numericUpDownMin.BackColor = Color.Red;
					MessageBox.Show("Daten im Feld Min dürfen nicht größer als der Messwert sein!");
					return;
				}
				// Überprüfung ob maximaler Messwert kleiner als Messwert
				else if (max <= measure)
				{
					numericUpDownMax.Focus();
					numericUpDownMax.BackColor = Color.Red;
					MessageBox.Show("Daten im Feld Max dürfen nicht kleiner als der Messwert sein!");
					return;
				}
			}
			else
			{
				textBoxData.Focus();
				textBoxData.BackColor = Color.Red;
				MessageBox.Show("Daten im Fehld Messwert dürfen nicht leer und müssen eine Zahl sein!");
				return;
			}

			text = textBoxText.Text;

			if (checkBoxGraph.Checked)
			{
				type = true;
			}

			// Picture Box Initialisieren
			start = true;
			pictureBoxDraw.Invalidate();
		}

		private void pictureBoxPaint_MouseMove(object sender, MouseEventArgs e)
		{
			// Mausposition erfassen
			MouseEventArgs eventMouse = (MouseEventArgs)e;
			mouseX = eventMouse.X;
			mouseY = eventMouse.Y;
			pictureBoxDraw.Invalidate();
		}

		private void pictureBoxPaint_MouseClick(object sender, MouseEventArgs e)
		{
			// Mausklick erfassen
			mouseCX = mouseX;
			mouseCY = mouseY;

			// Startfreigabe überprüfen
			if (start == false)
			{
				// Autoset für Testbench
				//textBoxData.Text = "20";
				//textBoxUnit.Text = "mV";
				//textBoxText.Text = "Beispiel";
				//numericUpDownMax.Value = 60;
				//numericUpDownMin.Value = -20;
				//checkBoxGraph.Checked = true;
				return;
			}
			
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

		private void pictureBoxPaint_Paint(object sender, PaintEventArgs e)
		{
			// Grafik Device erstellen und Kantenglättung aktivieren
			Graphics dev = e.Graphics;
			dev.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

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
				drawMeasureUnit(dev, mouseX, mouseY, distance, span, text, unit, min, max, measure, type, position, component);
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

				// Bauteilgröße bestimmen
				if (position == false)
				{
					distance = Math.Abs(mouseX - mouseCX);
					span = Math.Abs(mouseY - mouseCY);
				}
				else if (position == true)
				{
					distance = Math.Abs(mouseY - mouseCY);
					span = Math.Abs(mouseX - mouseCX);
				}

				// Bauteil Zeichnen (Distanz variabel)
				drawMeasureUnit(dev, mouseCX, mouseCY, distance, span, text, unit, min, max, measure, type, position, component);

				// Startposition speichern
				mouseSCX = mouseCX;
				mouseSCY = mouseCY;
			}
			else if (mouse == 2)
			{
				// Bauteil Fixieren
				drawMeasureUnit(dev, mouseSCX, mouseSCY, distance, span, text, unit, min, max, measure, type, position, component);
			}
		}

		private void drawMeasureUnit(Graphics dev, int x, int y, int distance, int span, string text, string unit, double min, double max, double measure, bool type, bool aligment, Color paint)
		{

			int scale = 40;      // Skalierung des Messbalken
			int offset = 10;    // Offset zwischen Bauteil und Text

			double position = (distance * measure) / (Math.Abs(min) + Math.Abs(max));

			// Font, Pinsel und Brushes aktivieren
			Font style = new Font("Verdana", 9);
			Pen linestyle = Pens.Black;
			Brush fillstyle = new SolidBrush(paint);
			Brush blackB = Brushes.Black;

			// Zeichenfolge Vertical zeichnen
			StringFormat drawVertical = new StringFormat(StringFormatFlags.DirectionVertical);

		if (type == false)
		{
			if (aligment == false)
			{
				// Messbalken
				dev.FillRectangle(fillstyle, x, y, distance, span);
				dev.DrawRectangle(linestyle, x, y, distance, span);
				dev.DrawRectangle(linestyle, x, y, distance, span);

				// Messwert
				dev.FillRectangle(blackB, (float)(x + position - (distance / scale)), (float)(y - (span / 5)), (float)(distance / (scale / 2)), (float)(span + ((span * 2) / 5)));

				// Beschriftung
				dev.DrawString(text, style, blackB, x, y - offset * 2);
				dev.DrawString(min.ToString(), style, blackB, x - offset / 2, y + span + offset);
				dev.DrawString(max.ToString(), style, blackB, x - offset + distance, y + span + offset);
			}
			if (aligment == true)
			{
				// Messbalken
				dev.FillRectangle(fillstyle, x, y - distance, span, distance);
				dev.DrawRectangle(linestyle, x, y - distance, span, distance);
				dev.DrawRectangle(linestyle, x, y - distance, span, distance);

				// Messwert
				dev.FillRectangle(blackB, (float)(x - (span / 5)), (float)(y - position - (distance / scale)), (float)(span + ((span * 2) / 5)), (float)(distance / (scale / 2)));

				// Beschriftung
				dev.DrawString(text, style, blackB, x - offset * 2, y - distance, drawVertical);
				dev.DrawString(min.ToString(), style, blackB, x + span + offset, y - offset / 2, drawVertical);
				dev.DrawString(max.ToString(), style, blackB, x + span + offset, y - offset - distance, drawVertical);
			}
		}
		else
		{

				// Messgerät Analog
				dev.DrawRectangle(linestyle, x - offset, y - span - offset, distance + offset * 2, span + offset * 2);
				dev.DrawLine(linestyle, x, y, x + distance, y);
				dev.DrawLine(linestyle, (float)(x + (distance / 2)), y - (offset / 2), (float)(x + (distance / 2)), y + (offset / 2));

				// Messwert DOES NOT WORK WITH AUTORESIZE!!!!
				// dev.DrawArc(linestyle, x, y, distance, 100, 0, 180);
				// dev.DrawPie(linestyle, x, y, 200, 100, 180, 180);

				dev.DrawString(distance.ToString(), style, blackB, x, y + span - offset * 4);
				dev.DrawString(span.ToString(), style, blackB, x, y + span - offset * 5);

				// Beschriftung
				dev.DrawString(text, style, blackB, x, y - span - offset * 3);
				dev.DrawString(min.ToString(), style, blackB, x - offset / 2, y + offset);
				dev.DrawString(max.ToString(), style, blackB, x - offset + distance, y + offset);
			}
		}
	}