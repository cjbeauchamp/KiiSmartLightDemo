import java.awt.BorderLayout;
import java.awt.CardLayout;
import java.awt.Color;
import java.awt.GridLayout;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.FileReader;

import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.SwingUtilities;
import javax.swing.Timer;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class LightBulbController
{	
	public static void main(final String[] args)
	{
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				GUI program = new GUI("SmartBulb", args[0]);
				program.setSize(800,800);
				program.setVisible(true);
			}
		});
	}
}



class GUI extends JFrame implements Constants, ActionListener
{
	JPanel cards;
	JPanel card;
	JPanel bulbPan = new JPanel();

	JLabel bulb;
	String smartlightFile = "";

	boolean power = false;
	float brightness = 0;
	Color colorRGB = Color.BLACK;

	public GUI(String arg, String smartlightFile)
	{
		super(arg);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setResizable(false);
		this.smartlightFile = smartlightFile;

		init();
	}

	public void init()
	{ 
		initCard2();
		setCards();
		add(cards);
	}

	public void initCard2()
	{
		JPanel top = new JPanel(new GridLayout(1, 0));

		bulbPan.setBackground(Color.BLACK);

		card = new JPanel(new BorderLayout());

		bulb = new JLabel(new ImageIcon(getClass().getResource("images/bulb.png"), "Image of a bulb"));
		bulbPan.add(bulb);
		top.add(bulbPan);

		card.add(top, BorderLayout.CENTER);
	}

	public void setCards()
	{
		cards = new JPanel(new CardLayout()); 
		cards.add(card, "CARD");

		ActionListener listener = new ActionListener(){
			public void actionPerformed(ActionEvent event){
				JSONParser parser = new JSONParser();
				try {

					FileReader fr = new FileReader(smartlightFile);
					Object obj = parser.parse(fr);

					JSONObject jsonObject = (JSONObject) obj;
					GUI.this.power = (boolean) jsonObject.get("power");

					JSONArray color = (JSONArray) jsonObject.get("color");

					int r = ((Long) color.get(0)).intValue();
					int g = ((Long) color.get(1)).intValue();
					int b = ((Long) color.get(2)).intValue();
					int a = ((Long) jsonObject.get("brightness")).intValue();

					GUI.this.colorRGB = new Color(r, g, b, a);

					paintStuff();
					fr.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		};
		Timer displayTimer = new Timer(1000, listener);
		displayTimer.start();
	}

	public void paintStuff()
	{
		if(this.power) {
			bulbPan.setBackground(this.colorRGB);
		} else {
			bulbPan.setBackground(Color.BLACK);
		}

		repaint();
	}

	public void actionPerformed(ActionEvent evt) {
		CardLayout c = (CardLayout)(cards.getLayout());
		c.next(cards);
	}

}

interface Constants
{
	final static Rectangle OFF_RECTANGLE = new Rectangle(30, 75, 35, 40); 
	final static Rectangle ON_RECTANGLE  = new Rectangle(25, 35, 35, 30);
}
