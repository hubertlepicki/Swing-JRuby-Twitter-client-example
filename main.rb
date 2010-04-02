require 'net/http'
require 'uri'
include Java

class QuickTweetWindow < javax.swing.JFrame
  import javax.swing
  include java.awt.event.ActionListener

  def initialize
    super
    self.getContentPane.setLayout BoxLayout.new(self.getContentPane(), BoxLayout::Y_AXIS)

    [ @login_label = JLabel.new("Twitter login:"),
      @login = JTextField.new,
      @password_label = JLabel.new("Twitter password:"),
      @password = JPasswordField.new,
      @your_tweet_label = JLabel.new("Your tweet:"),
      @tweet_text = JTextField.new,
      @ok_button = JButton.new("OK") ].each {|element| self.getContentPane.add element }
    self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
    self.pack
    self.set_visible true
    @ok_button.add_action_listener(self)
  end

  def actionPerformed(evt)
    send_tweet
  end

  def send_tweet
    puts "Trying to send a tweet"
    url = URI.parse('http://api.twitter.com/1/statuses/update.xml')
    req = Net::HTTP::Post.new(url.path)
    req.basic_auth @login.get_text, @password.get_text
    req.set_form_data({'status'=>@tweet_text.get_text}, ';')
    res = Net::HTTP.new(url.host, url.port).start {|http| http.request req }
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      JOptionPane.show_message_dialog self, "Your tweet has been sent!"
      @tweet_text.set_text ""
    else
      JOptionPane.show_message_dialog self, "Please check your login details... or something."
    end
  end
end

QuickTweetWindow.new
