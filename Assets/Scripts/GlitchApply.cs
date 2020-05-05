using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class GlitchApply : MonoBehaviour
{
    public GlitchIntro glitchIntro;
    private DialogTrigger dialogTrigger;

    private bool initiated = false;

    public bool effect = true;
    public float duration = 0.4f;
    public bool doshake = false;
    public float timeScale = 1f;
    public bool repeatable = false;
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (!initiated || repeatable)
        {
            initiated = true;
            if (duration == 0)
            {
                duration = Random.Range(0.3f, 0.5f);
            }

            if (effect)
            {
                StartCoroutine( glitchIntro.ApplyGlitch(true, duration, 3f, doshake, "glitch"+ (int)Random.Range(1,3), true, timeScale, glitchIntro.defaultSpriteMaterial ) );
            }
            
            dialogTrigger = GetComponent<DialogTrigger>();
            if (dialogTrigger)
            {
                dialogTrigger.TriggerDialog();
            }
        }
    }
    
}
