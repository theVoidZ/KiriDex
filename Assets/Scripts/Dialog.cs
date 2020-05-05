using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class Message
{
    [TextArea(3, 10)] 
    public string sentence;
    public float waiting = 3f;
}

[System.Serializable]
public class Dialog
{
    public string name;
    public Message[] sentences;
}
