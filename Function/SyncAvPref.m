function SyncAvPref()

    AvPref = getpref('AvPref');
    AvPref = orderfields(AvPref);
    save(AvPref.Path.AvPref,'AvPref');
    
end