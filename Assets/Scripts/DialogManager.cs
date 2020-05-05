using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.PlayerLoop;
using UnityEngine.UI;

public class DialogManager : MonoBehaviour
{
    private AudioManager audioManager;
    public GameObject frame;
    public Text nameText;
    public Text dialogText;
    public RawImage avatar; 
    public Texture2D devAvatar; 
    public Texture2D glitchAvatar; 

    public Queue<Message> sentences;
    
    // Start is called before the first frame update
    void Start()
    {
        audioManager = GetComponent<AudioManager>();
        sentences = new Queue<Message>();
        frame.SetActive(false);
    }

    public void StartDialogue(Dialog dialog)
    {
        if (dialog.name == "DevTeam")
        {
            avatar.texture = devAvatar;
        }
        else
        {
            avatar.texture = glitchAvatar;

        }
        nameText.text = dialog.name;
        
        sentences.Clear();

        foreach (Message item in dialog.sentences)
        {
            sentences.Enqueue( item );   
        }

        DisplayNextSentence();
    }

    public void DisplayNextSentence()
    {
        StopAllCoroutines();
        frame.SetActive(true);
        audioManager.PlaySound("discord");

        if (sentences.Count == 0)
        {
            StartCoroutine(EndDialog());
            return;
        }

        
        Message sentence = sentences.Dequeue();
        dialogText.text = sentence.sentence;
        StartCoroutine(NextDialog( sentence.waiting));

    }

    public IEnumerator NextDialog(float waiting)
    {
        yield return new WaitForSeconds(waiting);
        DisplayNextSentence();
    }
    
    public IEnumerator EndDialog()
    {
        yield return new WaitForSeconds(3f);
        frame.SetActive(false);
    }
    
    
    // Update is called once per frame
    void Update()
    {
        
    }
}
