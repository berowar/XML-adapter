before do
  Localize.locale = session['locale'] if session['locale']
end

helpers do
  def t
    @@trans ||= Localize.load
  end

  def l(source, format = :full)
    Localize.l(source, format)
  end

  def f(source, format = :full)
    Localize.f(source, format)
  end
end